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

begin constraint mass_property_cgx
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_cgx.xml
    is_linear false
    constraint_value 0 # target set within PA
    constraint_type equal_to
end

begin constraint mass_property_cgy
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_cgy.xml
    is_linear false
    constraint_value 0 # target set within PA
    constraint_type equal_to
end

begin constraint volume
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_volume.xml
    is_linear true
    constraint_value 0.32
    constraint_type equal_to
end

begin objective compliance
    active true
    app platoanalyze
    criterion platoanalyze
    input_files plato_analyze_mechanical_compliance.xml
    aggregation_weight 1.0
end

begin gradient_check
    output_file_name ROL_gradient_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 1
    direction_vector_type random
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check_output.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check_output.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check_output.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
    direction_vector_type random
end
