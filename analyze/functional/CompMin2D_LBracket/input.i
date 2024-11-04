begin density_topology
    mesh_name lbracket.exo
    output_name to-result.exo
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
    equal_to 0.32
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_to.xml
    aggregation_weight 1.0
    objective_type minimize
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
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check_output.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check_output.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
end
