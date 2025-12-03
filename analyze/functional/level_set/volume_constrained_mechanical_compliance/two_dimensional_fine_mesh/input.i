begin level_set_topology
    mesh_name square_mesh_refined_bg.exo
    output_name level-set-result.exo
    include_void_region false
    sphere_pattern radius 0.3 spacing 2.0 min (-0.5,-0.5, -0.5) max (0.5,0.5,0.5)
    level_set_bounds [-1, 1]
end

begin helmholtz_filter
    filter_radius 0.1
    use_relative_radius false
end

begin objective compliance
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.0
end

begin constraint volume
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_vol.xml
    is_linear false
    constraint_value 0.75
    constraint_type less_than
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 1 
    step_size_reduction_factor 0.1
    random_direction_seed 123
    direction_vector_type random
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
    direction_vector_type random
end
