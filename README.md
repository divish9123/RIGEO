# Task Scheduling in Fog Computing

[![arXiv](https://img.shields.io/badge/arXiv-2509.07378-b31b1b.svg)](https://arxiv.org/abs/2509.07378)

This repository contains a comparative study of various optimization algorithms for task scheduling in fog computing environments, focusing on energy efficiency, response time, deadline satisfaction, and cost optimization.

## Table of Contents
- [How to Run](#how-to-run)
- [How to Compile](#how-to-compile)
- [Project Structure](#project-structure)
- [Algorithms Overview](#algorithms-overview)
- [Performance Metrics](#performance-metrics)
- [References](#references)

---

## How to Run

### Prerequisites
- MATLAB R2018b or later
- All files must be in the same directory structure as provided

### Running the Simulation

1. **Open MATLAB**
   ```
   Start MATLAB application
   ```

2. **Navigate to the simulation directory**
   ```matlab
   cd /path/to/simulation
   ```

3. **Run the main script**
   ```matlab
   main
   ```

### Expected Output
- Traffic pattern generation for fog nodes
- Execution of 8 optimization algorithms (PSO, GWO, GEO, SOA, NSGA-II, WCLA+GA, ETFC, RIGEO)
- Generation of 8 comparison figures showing:
  - Average Total Response Time
  - Average Total Energy Consumption
  - Average Deadline Violation Time
  - Total Cost
  - Computational Overhead
  - Percentage of Tasks Meeting Deadline
  - Degree of Imbalancing (DI)
  - Utility of Fog Nodes
- Performance metrics calculated for each algorithm

---

## How to Compile

This is a MATLAB project and does not require traditional compilation. However, MATLAB will automatically parse and validate the code when you run it.

### Code Verification

To ensure all files are properly structured and there are no syntax errors:

```matlab
verify_compile
```

This script validates:
- ✅ All function references are correct
- ✅ All namespaces are properly configured
- ✅ No syntax errors
- ✅ All dependencies exist and are accessible

### Package Structure

The project uses MATLAB's package system (+ directories):
- `+fitness/` - Fitness functions
- `+operators/` - Genetic operators
- `+nsga/` - NSGA-II components
- `+utils/` - Utility functions

MATLAB automatically recognizes these packages, no compilation needed.

---

## Project Structure

```
simulation/
├── main.m                  # Main entry point
├── verify_compile.m        # Code verification script
├── COMPILATION_GUARANTEE.txt
│
├── Algorithm Files:
├── PSO.m                   # Particle Swarm Optimization
├── GWO.m                   # Grey Wolf Optimization
├── GEO.m                   # Golden Eagle Optimization
├── SOA.m                   # Seagull Optimization Algorithm
├── NSGA.m                  # Non-dominated Sorting Genetic Algorithm
├── IGEO.m                  # Improved Golden Eagle Optimization
├── WCLAGA.m                # WCLA + GA Algorithm
├── ETFC.m                  # Energy-Traffic-aware Fog Computing
├── RIGEO.m                 # Reinforcement IGEO (Proposed)
│
├── +fitness/               # Fitness functions package
│   ├── FitnessEnergy.m
│   ├── FitnessMultiObjective.m
│   └── FitnessCostMakespan.m
│
├── +operators/             # Genetic operators package
│   ├── GeneticMutation.m
│   ├── SimpleMutation.m
│   ├── GeneticCrossover.m
│   └── TournamentSelection.m
│
├── +nsga/                  # NSGA-II components package
│   ├── Dominates.m
│   ├── CalcCrowdingDistance.m
│   ├── NonDominatedSorting.m
│   └── SortPopulation.m
│
└── +utils/                 # Utility functions package
    ├── VectorNorm.m
    ├── CalculateMetrics.m
    ├── InitializeParameters.m
    ├── GenerateTaskTable.m
    ├── GenerateTrafficPattern.m
    └── UpdatePosition.m
```

**Total Files:** 27 MATLAB files

---

## Algorithms Overview

### 1. PSO - Particle Swarm Optimization
**Description:** A population-based stochastic optimization algorithm inspired by the social behavior of bird flocking and fish schooling, optimizing candidate solutions (particles) by moving them around the search space according to their own and swarm's best-known positions.

**Reference:** Kennedy, J., & Eberhart, R. (1995). [Particle swarm optimization](https://ieeexplore.ieee.org/document/488968). *Proceedings of ICNN'95 - International Conference on Neural Networks*, 4, 1942-1948.

---

### 2. GWO - Grey Wolf Optimizer
**Description:** A nature-inspired metaheuristic algorithm that mimics the leadership hierarchy and hunting mechanism of grey wolves, using alpha, beta, delta, and omega wolves to guide the search process.

**Reference:** Mirjalili, S., Mirjalili, S. M., & Lewis, A. (2014). [Grey wolf optimizer](https://www.sciencedirect.com/science/article/abs/pii/S0965997813001853). *Advances in Engineering Software*, 69, 46-61.

---

### 3. GEO - Golden Eagle Optimizer
**Description:** A swarm-intelligence metaheuristic algorithm inspired by the spiral trajectory and hunting behavior of golden eagles, balancing exploration (cruising) and exploitation (attacking) during optimization.

**Reference:** Mohammadi-Balani, A., Nayeri, M. D., Azar, A., & Taghizadeh-Yazdi, M. (2021). [Golden eagle optimizer: A nature-inspired metaheuristic algorithm](https://www.sciencedirect.com/science/article/abs/pii/S0360835220307208). *Computers & Industrial Engineering*, 152, 106994.

---

### 4. SOA - Seagull Optimization Algorithm
**Description:** A bio-inspired optimization algorithm that mathematically models the migration and attacking behaviors of seagulls in nature to solve large-scale industrial engineering problems.

**Reference:** Dhiman, G., & Kumar, V. (2019). [Seagull optimization algorithm: Theory and its applications for large-scale industrial engineering problems](https://www.sciencedirect.com/science/article/abs/pii/S0950705118305768). *Knowledge-Based Systems*, 165, 169-196.

---

### 5. NSGA-II - Non-dominated Sorting Genetic Algorithm II
**Description:** A fast and elitist multi-objective evolutionary algorithm that uses non-dominated sorting, crowding distance, and elitism to find Pareto-optimal solutions for multi-objective optimization problems.

**Reference:** Deb, K., Pratap, A., Agarwal, S., & Meyarivan, T. (2002). [A fast and elitist multiobjective genetic algorithm: NSGA-II](https://ieeexplore.ieee.org/document/996017). *IEEE Transactions on Evolutionary Computation*, 6(2), 182-197.

---

### 6. IGEO - Improved Golden Eagle Optimizer
**Description:** An enhanced version of GEO using Arnold chaotic map initialization, nonlinear convex weight reduction, and global optimization strategy to improve convergence and exploration capabilities.

**Reference:** Li, Y., et al. (2023). [A nonlinear convex decreasing weights golden eagle optimizer technique based on a global optimization strategy](https://www.mdpi.com/2076-3417/13/16/9394). *Applied Sciences*, 13(16), 9394.

---

### 7. WCLA+GA - Wavefront Cellular Learning Automata + Genetic Algorithm
**Description:** A hybrid algorithm combining wavefront cellular learning automata improved by genetic algorithm to accelerate automata convergence rate for efficient task scheduling in fog computing.

**Reference:** Jassbi, S. J., et al. (2023). [The improvement of wavefront cellular learning automata for task scheduling in fog computing](https://onlinelibrary.wiley.com/doi/10.1002/ett.4803). *Transactions on Emerging Telecommunications Technologies*, 34(7), e4803.

---

### 8. ETFC - Energy-efficient and Traffic-aware Fog Computing
**Description:** A traffic-aware task scheduling method that uses SVM to predict fog node loads, dividing nodes into low/high-traffic groups and applying reinforcement learning and metaheuristics for deadline-aware energy-efficient scheduling.

**Reference:** Pirmohammadi, M., et al. (2024). [ETFC: Energy-efficient and deadline-aware task scheduling in fog computing](https://www.sciencedirect.com/science/article/abs/pii/S2210537924000337). *Sustainable Computing: Informatics and Systems*, 42, 100969.

---

### 9. RIGEO - Reinforcement IGEO (Proposed Method)
**Description:** A novel hybrid algorithm that integrates traffic-aware node classification, deadline-based task partitioning, reinforcement learning for long-deadline tasks, and IGEO optimization for short-deadline tasks to optimize fog computing task scheduling.

**Reference:** Proposed algorithm in this work - combines traffic prediction, deadline awareness, and adaptive reinforcement learning with IGEO metaheuristic for superior performance in fog computing environments.

---

## Performance Metrics

The simulation evaluates all algorithms across multiple performance indicators:

- **Response Time (ms)**: Average total response time for task execution
- **Energy Consumption (J)**: Total energy consumed by fog nodes
- **Deadline Violation Time (ms)**: Total time by which task deadlines are missed
- **Cost ($)**: Monetary cost of task execution
- **Computational Overhead (s)**: Time complexity of the algorithm itself
- **Tasks Meeting Deadline (%)**: Percentage of tasks completed within their deadline
- **Degree of Imbalancing (DI)**: Load distribution balance across fog nodes
- **Utility (%)**: Resource utilization efficiency of fog nodes

---

## References

### Algorithm References

1. **PSO**: Kennedy, J., & Eberhart, R. (1995). [Particle swarm optimization](https://ieeexplore.ieee.org/document/488968). *Proceedings of ICNN'95 - International Conference on Neural Networks*, 4, 1942-1948.

2. **GWO**: Mirjalili, S., Mirjalili, S. M., & Lewis, A. (2014). [Grey wolf optimizer](https://www.sciencedirect.com/science/article/abs/pii/S0965997813001853). *Advances in Engineering Software*, 69, 46-61.

3. **GEO**: Mohammadi-Balani, A., Nayeri, M. D., Azar, A., & Taghizadeh-Yazdi, M. (2021). [Golden eagle optimizer: A nature-inspired metaheuristic algorithm](https://www.sciencedirect.com/science/article/abs/pii/S0360835220307208). *Computers & Industrial Engineering*, 152, 106994.

4. **SOA**: Dhiman, G., & Kumar, V. (2019). [Seagull optimization algorithm: Theory and its applications for large-scale industrial engineering problems](https://www.sciencedirect.com/science/article/abs/pii/S0950705118305768). *Knowledge-Based Systems*, 165, 169-196.

5. **NSGA-II**: Deb, K., Pratap, A., Agarwal, S., & Meyarivan, T. (2002). [A fast and elitist multiobjective genetic algorithm: NSGA-II](https://ieeexplore.ieee.org/document/996017). *IEEE Transactions on Evolutionary Computation*, 6(2), 182-197.

6. **IGEO**: Li, Y., et al. (2023). [A nonlinear convex decreasing weights golden eagle optimizer technique based on a global optimization strategy](https://www.mdpi.com/2076-3417/13/16/9394). *Applied Sciences*, 13(16), 9394.

7. **WCLA+GA**: Jassbi, S. J., et al. (2023). [The improvement of wavefront cellular learning automata for task scheduling in fog computing](https://onlinelibrary.wiley.com/doi/10.1002/ett.4803). *Transactions on Emerging Telecommunications Technologies*, 34(7), e4803.

8. **ETFC**: Pirmohammadi, M., et al. (2024). [ETFC: Energy-efficient and deadline-aware task scheduling in fog computing](https://www.sciencedirect.com/science/article/abs/pii/S2210537924000337). *Sustainable Computing: Informatics and Systems*, 42, 100969.

### Additional Resources

- [PSO Historical Review](https://pmc.ncbi.nlm.nih.gov/articles/PMC7516836/)
- [GEO MATLAB Toolbox](https://www.mathworks.com/matlabcentral/fileexchange/84430-golden-eagle-optimizer-toolbox)
- [NSGA-II Algorithm Overview](https://www.sciencedirect.com/topics/computer-science/non-dominated-sorting-genetic-algorithm-ii)
- [Fog Computing Task Scheduling Survey](https://www.sciencedirect.com/science/article/abs/pii/S1574013723000175)
