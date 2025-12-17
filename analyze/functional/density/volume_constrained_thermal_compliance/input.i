begin density_topology
    mesh_name circle.exo
    output_name to-result.exo
    fixed_blocks fixed_block
    initial_density_value 0.431
end

begin kernel_filter
    filter_radius 3
    use_relative_radius true
    centering_type node
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear true
    constraint_value 150
    constraint_type equal_to
end

begin objective thermal_compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_thermal_compliance.xml
    normalize_by_initial_value true
    aggregation_weight 1.0
end

begin rol_optimization
    max_iterations 3
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.5
    random_direction_seed 1
    direction_vector_type random
end
