---
name: optimize-graph
description: Optimize visNetwork performance for large document graphs
agent: shiny-dev
---

# Optimize Graph Performance

Improve rendering performance for large visNetwork graphs.

## Input

- **Estimated Node Count:** ${input:nodeCount:Approximate number of nodes to display}

## Context

This application visualizes document relationships with potentially thousands of nodes. Large graphs cause:
- Slow initial render
- UI freezing during interaction
- Browser memory issues

## Optimization Strategies

Based on node count, apply these techniques:

### Small Graphs (< 100 nodes)
- No optimization needed
- Enable physics for nice layout

### Medium Graphs (100-500 nodes)
- Disable physics after initial layout: `stabilizationIterations`
- Use hierarchical layout if applicable
- Reduce edge smoothness

### Large Graphs (500-2000 nodes)
- **Cluster nodes** by document type or pattern
- Show only top N connections per node
- Lazy load node details on click
- Disable labels until zoom

### Very Large Graphs (> 2000 nodes)
- **Server-side pagination** — show subset at a time
- Aggregate nodes into summary clusters
- Use canvas renderer if available
- Consider alternative viz (reactable with sparklines)

## Implementation Patterns

### Clustering
```r
visNetwork::visClusteringByGroup(
  groups = document_types,
  label = "Documents: ",
  shape = "database"
)
```

### Progressive Loading
```r
# Initial render with subset
visNetwork(nodes_subset, edges_subset) |>
  visEvents(
    click = "function(nodes) {
      Shiny.setInputValue('clicked_node', nodes.nodes[0]);
    }"
  )

# Server: load more on click
observeEvent(input$clicked_node, {
  # Expand cluster or load adjacent nodes
})
```

### Physics Optimization
```r
visPhysics(
  stabilization = list(iterations = 100),
  solver = "forceAtlas2Based",
  forceAtlas2Based = list(gravitationalConstant = -50)
) |>
visEvents(stabilized = "function() { this.setOptions({physics: false}); }")
```

## Checklist

- [ ] Profile current render time
- [ ] Identify bottleneck (data, rendering, physics)
- [ ] Apply appropriate strategy for node count
- [ ] Test with realistic data volume
- [ ] Verify memory usage in browser
