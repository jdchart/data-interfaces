<script lang="ts">
import { onMount } from "svelte";
import * as d3 from "d3";

export let dataUrl: string;
export let width = 800;
export let height = 600;
export let onSelect: (nodes: any[]) => void | Promise<void> = () => {};

let svgEl: SVGSVGElement;
let tooltipEl: HTMLDivElement;

let data: any[] = [];
let selected = new Set<any>();
let transform = d3.zoomIdentity;
let tooltipTimer: any;

onMount(async () => {
    data = await (await fetch(dataUrl)).json();
    render();
});

function render() {
    const svg = d3.select(svgEl)
        .attr("width", width)
        .attr("height", height)
        .style("user-select", "none");

    const x = d3.scaleLinear().domain([0, 1]).range([40, width - 40]);
    const y = d3.scaleLinear().domain([0, 1]).range([height - 40, 40]);

    const plot = svg.append("g");

    // ---- ZOOM ----
    const zoom = d3.zoom<SVGSVGElement, unknown>()
        .filter(e => e.type === "wheel" || e.altKey)
        .scaleExtent([0.5, 10])
        .on("zoom", e => {
            transform = e.transform;
            plot.attr("transform", transform);
        });
    svg.call(zoom as any);

    // ---- POINTS ----
    const circles = plot.selectAll("circle")
        .data(data)
        .join("circle")
        .attr("cx", d => x(d.x))
        .attr("cy", d => y(d.y))
        .attr("r", d => 4 + d.size * 10)
        .attr("fill", d => d.cluster === -1 ? "#999" : d3.schemeCategory10[d.cluster % 10])
        .attr("stroke", "#000")
        .attr("stroke-width", 0.5)
        .style("cursor", "pointer")
        .on("click", (event, d) => {
            event.stopPropagation(); // prevent background click
            if (!event.shiftKey) clearSelection();
            toggleSelection(d, event.currentTarget);
            onSelect([...selected]);
        })
        .on("mouseenter", showTooltip)
        .on("mousemove", moveTooltip)
        .on("mouseleave", hideTooltip);

    // ---- CLICK ON BACKGROUND TO CLEAR ----
    svg.on("click", () => {
        clearSelection();
        onSelect([...selected]);
    });

    // ---- KEYBOARD SHORTCUTS ----
    svgEl.addEventListener("keydown", e => {
        if (e.key === "Escape") {
            // Clear selection
            clearSelection();
            onSelect([...selected]);
        }
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "a") {
            e.preventDefault();
            // Select all points currently in view
            clearSelection();
            circles.each(function(d){
                const cx = transform.applyX(x(d.x));
                const cy = transform.applyY(y(d.y));
                if (cx >= 0 && cx <= width && cy >= 0 && cy <= height) selectNode(d, this);
            });
            onSelect([...selected]);
        }
    });

    // ---- SELECTION HELPERS ----
    function selectNode(d, el) {
        if (selected.has(d)) return;
        selected.add(d);
        d3.select(el).attr("stroke", "red").attr("stroke-width", 2);
    }

    function toggleSelection(d, el) {
        if (selected.has(d)) {
            selected.delete(d);
            d3.select(el).attr("stroke", "#000").attr("stroke-width", 0.5);
        } else {
            selectNode(d, el);
        }
    }

    function clearSelection() {
        selected.clear();
        circles.attr("stroke", "#000").attr("stroke-width", 0.5);
    }

    // ---- TOOLTIP ----
    function showTooltip(event, d) {
        clearTimeout(tooltipTimer);
        tooltipEl.style.opacity = "1";
        tooltipEl.innerHTML = `
            <strong>${d.word}</strong><br/>
            Count: ${d.count}<br/>
            Cluster: ${d.cluster}
        `;
        moveTooltip(event);
    }

    function moveTooltip(event) {
        tooltipEl.style.left = event.clientX + 12 + "px";
        tooltipEl.style.top = event.clientY + 12 + "px";
    }

    function hideTooltip() {
        tooltipTimer = setTimeout(() => {
            tooltipEl.style.opacity = "0";
        }, 250);
    }
}
</script>

<svg bind:this={svgEl} tabindex="0"></svg>
<div bind:this={tooltipEl} class="tooltip"></div>

<style>
.tooltip {
    position: fixed;
    pointer-events: none;
    background: rgba(0, 0, 0, 0.85);
    color: #fff;
    padding: 6px 8px;
    border-radius: 4px;
    font-size: 12px;
    opacity: 0;
    transition: opacity 0.15s ease;
    z-index: 1000;
}
</style>
