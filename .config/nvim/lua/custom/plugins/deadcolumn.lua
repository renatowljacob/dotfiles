return {
  "Bekaboo/deadcolumn.nvim",
  config = function ()
    local opts = {
      scope = 'line',
      modes = { 'n', 'i', 'ic', 'ix', 'R', 'Rc', 'Rx', 'Rv', 'Rvc', 'Rvx' },
      blending = {
        threshold = 0.90,
        colorcode = '#3b4261',
        hlgroup = {
            'Normal',
            'background',
        },
      },
      warning = {
        alpha = 0.4,
        offset = -1,
        colorcode = '#3b4261',
        hlgroup = {
            'Error',
            'background',
        },
      },
      extra = {
          follow_tw = nil,
      },
    }

    require('deadcolumn').setup(opts) -- Call the setup function
  end,
}
