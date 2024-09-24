begin density_topology
    mesh_name multiblock_Lbracket.exo
    output_name output.exo
    fixed_blocks block_1, block_4
end

begin kernel_filter
    filter_radius 0.3
    centering_type element
end

begin constraint volume_fraction
    criterion volume_fraction
    is_linear true
    equal_to 0.3
end

begin objective compliance
    app sierra_sd
    criterion compliance
    number_of_processors 1
    input_files salinas_input.i
    aggregation_weight 1.0
end

begin rol_optimization 
    input_file_name rol_inputs.xml
    step_tolerance 1e-10
    gradient_tolerance 1e-5
    max_iterations 5
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.5
    random_direction_seed 1
end
