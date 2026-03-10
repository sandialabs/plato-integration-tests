begin density_topology
    mesh_name multiblock_Lbracket.exo
    output_name to-result.exo
    initial_density_value 0.5
end

begin kernel_filter
    filter_radius 2.1
    centering_type element
    use_relative_radius true
end

begin constraint stress
    app sierra_sd
    criterion von_mises_stress_squared
    input_files salinas-input.i
    is_linear false
    constraint_value 2000.0
    constraint_type less_than
end

begin objective volume
    criterion volume
    aggregation_weight 1.0 
    normalize_by_initial_value true
end

begin constraint_check
    linearity_check_output_file_name constraint_linearity_check.txt
    jacobian_check_output_file_name constraint_jacobian_check.txt
    jacobian_adjoint_consistency_output_file_name constraint_jacobian_adjoint_consistency_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.05
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end
