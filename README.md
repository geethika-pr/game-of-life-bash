# Game of Life — RISC-V Mentorship Coding Challenge

A bash implementation of Conway's Game of Life, submitted as part of the RISC-V Mentorship coding challenge.

## Approach

The grid is a changable toroidal (wrap-around) space. Each generation, every cell's next status is decided by its 8 neighbors:
- **Underpopulation:** A live cell with fewer than 2 live neighbors dies
- **Survival:** A live cell with 2 or 3 live neighbors lives on
- **Overpopulation:** A live cell with more than 3 live neighbors dies
- **Reproduction:** A dead cell with exactly 3 live neighbors becomes alive

A randomized seed is placed at the center of the grid to start the simulation.

## Run

```bash
chmod +x glife.sh
./glife.sh
```

## Key iteration points

| Function | Purpose |
|---|---|
| `initialize_grid` | Seeds the starting cell configuration |
| `count_neighbors` | A defined window scan for each cell each generation |
| `update_grid` | Computes the next generation into a separate grid, then syncs back |
| Main loop | Runs infinitely, displaying and updating each update |
