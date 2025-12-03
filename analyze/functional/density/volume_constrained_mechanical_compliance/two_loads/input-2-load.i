begin density_topology
    mesh_name lbracket.exo
    output_name to-result-2-load.exo
    initial_density_value 0.5
end

begin helmholtz_filter
    filter_radius 2.5e-2
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol.xml
    is_linear true
    constraint_value 0.32
    constraint_type equal_to
end

begin objective compliance-1
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_to.xml
    aggregation_weight 0.5
end

begin objective compliance-2
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_to.xml
    aggregation_weight 0.5
end

begin rol_optimization
    max_iterations 5
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 1
    direction_vector_type random
end
