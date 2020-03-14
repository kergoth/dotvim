# Kergoth's .vim

## Usage

```
git clone https://github.com/kergoth/dotvim /whereever/you/want/it
```

If you want to run these in place without disrupting your existing vim setup,
run:
```
/whereever/you/want/it/script/bootstrap
```

And then run vim with `vim -u /whereever/you/want/it/vimrc`

To instead make this default, run:
```
/whereever/you/want/it/script/install
```

## Key functionality included

## Reference for Vim commands/mappings

### Builtin

- `:cq`: Exit non-zero.
- `g*` Like "*", but don't put "\<" and "\>" around the word. This makes the
  search also find matches that are not a whole word.

### .vim/vimrc

### From plugins

imap `<C-x><C-t>`: Complete minisnip snippets.

## Reference Links

- [Vim: available lowercase key pairs in normal mode](https://gist.github.com/romainl/1f93db9dc976ba851bbb)
    - See also [Follow my leader](http://vimcasts.org/blog/2014/02/follow-my-leader/)
