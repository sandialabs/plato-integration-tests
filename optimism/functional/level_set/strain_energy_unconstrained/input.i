begin level_set_topology
    mesh_name window_bg.exo
    output_name level-set-result.exo
    include_void_region false
    sphere_pattern radius 0.35 spacing 2.0 min (-0.5,-0.5,-0.5) max (0.5,0.5,0.5)
    level_set_bounds [-1, 1]
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
