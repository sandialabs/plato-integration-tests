begin brick_shape_geometry
    mesh_name brick.exo
end

begin objective modal_match
    app sierra_sd
    criterion modal
    number_of_processors 1
    input_files sd_modal.i
    aggregation_weight 1.0
end

begin gradient_check
    output_file_name ROL_gradient_check.txt
    number_of_steps 10
    initial_direction_magnitude 0.1
    step_size_reduction_factor 0.5
    random_direction_seed 1
end
