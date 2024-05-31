begin density_topology
    mesh_name lbracket.exo
    output_name to-result.exo
    filter_type helmholtz
    filter_radius 2.5e-2
end

begin constraint p_norm
    active true
    app platoanalyze
    input_files plato_analyze_p_norm.xml
    is_linear false
    equal_to 4.3e+03
end

begin objective compliance
    active true
    app platoanalyze
    input_files plato_analyze_to.xml
    aggregation_weight 1.0
    objective_type minimize
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
