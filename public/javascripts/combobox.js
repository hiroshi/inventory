// LocalCombo provides 'toggle' method to show/hide autocompletion options.
// This is intended to implement a combo-box.
Autocompleter.LocalCombo = Class.create(Autocompleter.Local, {
  version: 0.1, // implemented with script.aculo.us 1.8.0.1 (maybe) and prototype.js 1.6.0.3
  initialize: function(element, update, array, options) {
    this.baseInitialize(element, update, options);
    this.options.array = array;
    // re-register fixed 'onBlur' handler
    Event.stopObserving(this.element, 'blur', false);
    Event.observe(this.element, 'blur', this.onBlur.bindAsEventListener(this));
  },

  onBlur: function(event) {
    // Don't try to hide the list if it doesn't visible
    if (Element.visible(this.update)) setTimeout(this.hide.bind(this), 250);
    this.hasFocus = false;
    this.active = false;
  },

  getAllChoices: function() {
    var ret = [];
    for (var i=0; i< this.options.array.length && ret.length < this.options.choices; i++) {
      var elem = this.options.array[i];
      ret.push("<li>" + elem + "</li>");
    }
    this.update.innerHTML = "<ul>" + ret.join('') + "</ul>";
    this.entryCount = ret.length;
    for (var i = 0; i < this.entryCount; i++) {
      var entry = this.getEntry(i);
      entry.autocompleteIndex = i;
      this.addObservers(entry);
    }
  },

  toggle: function() {
    if (Element.visible(this.update)) {
      this.hide();
    } else {
      this.tokenBounds = null;
      this.element.focus();
      //if (this.entryCount < 1) this.getAllChoices();
      this.getAllChoices();
      this.show();
    }
  }
});
