begin density_topology
    mesh_name ball_in_cup.exo
    output_name to-result.exo
    initial_density_value 0.25
    fixed_blocks block_2
end

begin kernel_filter
    filter_radius 1.5
    centering_type node
    use_relative_radius true
end

begin constraint volume
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol.xml
    constraint_value 40.0
    constraint_type equal_to
    is_linear true
end

begin objective compliance
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0
end

begin rol_optimization
    max_iterations 3
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 8
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
    direction_vector_type random
end
