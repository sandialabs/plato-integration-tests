begin brick_shape_geometry
    mesh_name brick.exo
end

begin constraint mass_properties
    app sierra_sd
    criterion mass-properties
    input_files salinas_input.i
    constraint_value_list component volume target 2.0,
                          component mass target 4.0,
                          component cg_x target 6.0,
                          component cg_y target 8.5,
                          component cg_z target 10.0,
                          component i_xx target -1.0,
                          component i_yy target 1.0,
                          component i_zz target 2.0,
                          component i_xy target 3.0,
                          component i_yz target 4.0,
                          component i_zx target 5.0

    constraint_type equal_to
    is_linear false
end

begin objective modal_match
    app sierra_sd
    criterion modal
    number_of_processors 1
    input_files sd_modal.i
    aggregation_weight 1.0
end

begin constraint_check
    linearity_check_output_file_name ROL_constraint_linearity_check.txt
    jacobian_check_output_file_name ROL_constraint_jacobian_check.txt
    jacobian_adjoint_consistency_output_file_name ROL_constraint_jacobian_adjoint_consistency_check.txt
    number_of_steps 10
    initial_direction_magnitude 1
    step_size_reduction_factor 0.1
    random_direction_seed 123
end

