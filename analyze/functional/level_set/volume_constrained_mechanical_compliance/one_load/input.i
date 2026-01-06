begin level_set_topology
    mesh_name lbracket3d.exo
    output_name level-set-result.exo
    include_void_region true
    sphere_list radius 0.125 center (-.3,0.2,0)
    level_set_bounds [-.1, 1]
    max_edge_length_percentage_for_snapping 0.5
end

begin kernel_filter
    filter_radius 0.05
    centering_type node
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear false
    constraint_type equal_to
    constraint_value 1600
end

begin objective compliance
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_compliance.xml
    aggregation_weight 1.e2
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 0.05
    step_size_reduction_factor 0.1
    direction_vector_type uniform_positive
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check_output.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check_output.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
    direction_vector_type uniform_positive
end
