begin density_topology
    mesh_name lbracket.exo
    output_name to-result.exo
    initial_density_value 0.5
end

begin kernel_filter
    filter_radius 2
    centering_type node
    use_relative_radius true
end

begin constraint p_norm
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_p_norm.xml
    is_linear false
    constraint_value 2e6
    constraint_type less_than
end

begin objective mass
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mass.xml
    aggregation_weight 1.0 
end

begin rol_optimization
    max_iterations 3
    approximate_hessian true
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end
