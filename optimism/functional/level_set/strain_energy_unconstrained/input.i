begin level_set_topology
    mesh_name window_bg.exo
    output_name level-set-result.exo
    include_void_region false
    sphere_pattern_bbox_min_x -0.5
    sphere_pattern_bbox_min_y -0.5
    sphere_pattern_bbox_min_z -0.5
    sphere_pattern_bbox_max_x 0.5
    sphere_pattern_bbox_max_y 0.5
    sphere_pattern_bbox_max_z 0.5
    sphere_pattern_radius .35
    sphere_pattern_spacing 2.0
    level_set_lower_bound -1.0
    level_set_upper_bound 1.0
end

begin kernel_filter
    centering_type node
    filter_radius 2.0
    use_relative_radius true
end

begin objective strain_energy
    app plato-python-app
    criterion plato-python-app
    input_files plato-python-app-input.xml
    aggregation_weight 1.0
end

begin rol_optimization
    max_iterations 5
    output_design_history true
end
