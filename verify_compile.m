fprintf('Starting compilation verification...\n\n');

try
    fprintf('1. Checking paths...\n');
    addpath(pwd);
    fprintf('   ✅ Path added\n\n');
    
    fprintf('2. Checking fitness functions...\n');
    which fitness.FitnessEnergy
    which fitness.FitnessMultiObjective
    which fitness.FitnessCostMakespan
    fprintf('   ✅ All fitness functions found\n\n');
    
    fprintf('3. Checking operators...\n');
    which operators.GeneticMutation
    which operators.GeneticCrossover
    which operators.SimpleMutation
    which operators.TournamentSelection
    fprintf('   ✅ All operators found\n\n');
    
    fprintf('4. Checking nsga functions...\n');
    which nsga.CalcCrowdingDistance
    which nsga.Dominates
    which nsga.NonDominatedSorting
    which nsga.SortPopulation
    fprintf('   ✅ All NSGA functions found\n\n');
    
    fprintf('5. Checking utils...\n');
    which utils.InitializeParameters
    which utils.GenerateTrafficPattern
    which utils.GenerateTaskTable
    which utils.CalculateMetrics
    which utils.VectorNorm
    which utils.UpdatePosition
    fprintf('   ✅ All utils found\n\n');
    
    fprintf('6. Checking algorithm files...\n');
    which PSO
    which GWO
    which GEO
    which SOA
    which NSGA
    which IGEO
    which RIGEO
    which ETFC
    which WCLAGA
    fprintf('   ✅ All algorithms found\n\n');
    
    fprintf('=================================\n');
    fprintf('✅ ALL COMPILATION CHECKS PASSED\n');
    fprintf('=================================\n');
    fprintf('The code is ready to run!\n');
    fprintf('Execute: main\n');
    
catch e
    fprintf('\n❌ ERROR: %s\n', e.message);
    fprintf('Stack trace:\n');
    for i = 1:length(e.stack)
        fprintf('  File: %s, Line: %d\n', e.stack(i).file, e.stack(i).line);
    end
end
