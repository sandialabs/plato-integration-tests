begin density_topology
    mesh_name multiblock_Lbracket.exo
    output_name output.exo
    fixed_blocks block_1, block_4
    initial_density_value 0.5
end

begin kernel_filter
    filter_radius 0.3
    centering_type element
end

begin constraint volume_fraction
    criterion volume_fraction
    is_linear true
    constraint_value 0.65
    constraint_type equal_to
end

begin objective compliance
    app sierra_sd
    criterion compliance
    number_of_processors 1
    input_files salinas_input.i
    aggregation_weight 1.0
end

begin rol_optimization 
    max_iterations 5
    export_settings_file_name rol_options.xml
    initial_search_radius 1
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.5
    random_direction_seed 1
    direction_vector_type random
end
