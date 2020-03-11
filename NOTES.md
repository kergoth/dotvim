- qfsign only works on quickfix not loclist
- current lint setup doesn't update the qf list when switching buffers, only
  when the file is read or written, which is a problem. likely need to cache
  and load/unload across window switch, or just use the location list. but
  even using the location list is problematic, as it's associated with the
  *window*, not the *buffer*, while linting is against the buffer/file. so
  I think in either case I need to save/restore the list, though less often if
  it's the location list, since it'd only be when switching buffers in the
  window, not when switching between windows.
- is there a better way to avoid opening the window by default without
  impacting the user if they wanted it to stay open? should I just keep the
  damn thing open all the time?
