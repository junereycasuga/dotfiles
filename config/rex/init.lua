-- TABS --
rex.bind("ctrl+space>c", "client.tab.new")

-- PANES --
rex.bind("ctrl+space>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+space>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+space>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+space>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+space>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+space>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+space>z", "pane.zoom")

-- PANE RESIZE --
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+space>r", "client.mode.enter", { name = "resize" })

rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/l", "pane.resize", { direction = "right" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/j", "pane.resize", { direction = "down" })

-- Hold shift for bigger steps
rex.bind("resize/shift+h", "pane.resize", {
  direction = "left",
  amount = 15,
})
rex.bind("resize/shift+l", "pane.resize", {
  direction = "right",
  amount = 15,
})

rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
