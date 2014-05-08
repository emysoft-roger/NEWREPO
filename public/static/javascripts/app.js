//@prepros-append min/jquery.validationEngine.min.js
//@prepros-append min/jquery.validationEngine-fr.min.js
//@prepros-append min/jquery.colorbox.min.js
//@prepros-append min/jquery.sticky-kit.min.js
//@prepros-append min/jquery.jqEasyCharCounter.min.js
//@prepros-append min/jquery.equalheights.min.js


// DOM CACHE
$C = (function($){
    var DOMCACHESTORE = {};

    return function(selector, force) {
            if (DOMCACHESTORE[selector] !== undefined && !force) {
                return DOMCACHESTORE[selector];
            }

            DOMCACHESTORE[selector] = $(selector);
            return DOMCACHESTORE[selector];
        };
})($);

MainApp = {
    init: function() {
      MainApp.toggles();
      MainApp.popin();
      MainApp.sameheight();
    },

    sameheight: function() {
      $('.sameheight').equalHeights();
      // $(window).resize(function(){
      //   $('.sameheight').height('auto');
      //   $('.sameheight').equalHeights();
      // });
    },

    counter: function () {
      $('.input-count-115').jqEasyCounter({
        'maxChars': 115,
        'maxCharsWarning': 115,
        'msgTextAlign': 'left',
        'msgWarningColor': '#C00'
        // 'msgAppendMethod': 'insertBefore'
      });
      $('.input-count-700').jqEasyCounter({
        'maxChars': 700,
        'maxCharsWarning': 700,
        'msgTextAlign': 'left',
        'msgWarningColor': '#C00'
        // 'msgAppendMethod': 'insertBefore'
      });
      $('.input-count-1500').jqEasyCounter({
        'maxChars': 1500,
        'maxCharsWarning': 1500,
        'msgTextAlign': 'left',
        'msgWarningColor': '#C00'
        // 'msgAppendMethod': 'insertBefore'
      });
    },

    form: function () {
        $('form').validationEngine({
            binded: true
        });

        $('.js-skip-validate').on('click', function(e) {
          e.preventDefault();
          var $form = $(this).parents("form");
          $form.validationEngine('detach');
          $form.submit();
        });
    },

    password: function () {
        var check = function (passwordId, checkboxId) {
            var checkBox = document.getElementById(checkboxId);
            var passWord = document.getElementById(passwordId);
            passWord.type = checkBox.checked ? 'text' : 'password';
        };

        $C('.js-pass-toggle').on('click', function() {
            var $this = $(this);
            check($this.attr('data-input'), this.id);
        });
    },

    modif_profile: function() {
      // Delete:
      $('.js-del-field').live("click", function(e){
        e.preventDefault();

        var $bloc = $(this).parents('[data-group]');
        bid = $bloc.attr('data-group');
        $blocs = $('[data-group=' + bid + ']');

        var $parents = $(this).parent().parent();
        var $add = $parents.find('.js-add-field');

        if ($add.length === 0) {$add = $parents.parent().find('.js-add-field');}

        var $targetElem = $blocs.parent().find('.js-select');

        $targetElem.each(function(div, i) {
          $(this).find("option").removeAttr('disabled');
        });

        // Removes all blcs with same identifier, via data-group
        $blocs.remove();

        // show add btn
        $add.show();

        return false;
      });

      // Add:
      var max = 3;

      $('.js-add-field').live("click", function(e){
        e.preventDefault();

        var $this = $(this);
        // var kind = $this.attr('data-field');

        // big parent wrapper
        var $parents = $this.parent().parent();
        // take each group if needed
        var $groups = $parents.find('.js-group');
        var isSearch = null;
        if ($groups.length > 0) {
          isSearch = 0;
        }
        else {
          isSearch = 1;
          $groups = $parents.find('.duplicate-item').first();
        }

        // Get frst group to have the number of rows
        var $firstGroup = $groups.first();
        // Rows in first group
        var $rows = $firstGroup.find('.duplicate-item');

        if ($rows.length >= max) {
            $this.hide();
            return false;
        }

        if (isSearch === 1) {$rows = $parents.find('.duplicate-item');}

        // each on groups , example: selector + year in diferent columns
        $groups.each(function(div, i) {
          var $this = $(this);

          // rows for this column
          var $rows = $this.find('.duplicate-item');
          if (isSearch === 1) { $rows = $parents.find('.duplicate-item'); }

          // Take the element to duplicate (input + html decorators)
          var $toDuplicate = $rows.last();
          var clone = $toDuplicate.clone();
          clone.find(".formError").remove();

          $cloneField = clone.find('select, input, textarea');
          var previousGroup = clone.attr('data-group');

          // Increment number
          var newNumber = $rows.length;
          var newGroup = previousGroup.replace(newNumber - 1, newNumber + '');

          $cloneField.attr('id', '');
          $cloneField.val('');
          clone.attr('data-group', newGroup);

          // Append clone
          // $this.append(clone);
          (isSearch === 1) ? $toDuplicate.after(clone) : $this.append(clone);
          // display "remove button"
          clone.find('a').show();
        });


        if ($rows.length === max-1) {
            $this.hide();
        }

        return false;
      });

    },

    complete_optional_fields: function(){
      $(".js-optional").change(function(e) {
        e.preventDefault();

        $this = $(this);
        $target = $this.parent().parent();
        $emptyFields = $target.find("input[value=], textarea[value=]").length;

        if ($emptyFields === 3)
        {
          $target.find("input[class*=required], textarea[class*=required]").each(function( i ) {
            var textClass = $(this).attr("class").replace("validate[required,","validate[");
            $(this).attr("class",textClass);
          });

        } else {
          $target.find("input,textarea").not('[class*=required]').each(function( i ) {
            var textClass = $(this).attr("class").replace("validate[","validate[required,");
            $(this).attr("class",textClass);
          });
        }

        return false;
      });
    },

    select_disable: function () {
      $('.js-select').live("focusin", function(e){
        e.preventDefault();
        $this = $(this);

        $this.find("option").removeAttr('disabled');

        var $selectedElem = $this.parent().parent().find('.js-select');

        $selectedElem.each(function(div, i) {
          $this.find("option[value="+ $(this).val() + "]").attr('disabled', true);
        });
          $this.find("option[value="+ $this.val() + "]").attr('disabled', false);
      });
    },

    toggles: function () {
      $('.js-toggle').on('click', function(e) {
        e.preventDefault();
        var $this = $(this);

        var $div = $C('#' + $this.attr('data-target'));

        $div.toggle(10, function() {

          var letter = ( $div.is(":visible") ) ? "q" : "f";
          $this.find('span').attr('data-icon', letter);

          var text = false;
          if ( $div.is(":visible") ) {
            text = $this.attr('data-text-open');
          } else {
            text = $this.attr('data-text-close');
          }

          if (text) {
            $this.text(text);
          }
        });

        return false;
      });
    },

    tiny: function  () {
      tinymce.init({
        selector:'.tiny-mce',
        mode: "textareas",
        toolbar: "bold italic bullist",
        statusbar: true,
        width: 750,
        height: 300,
        language : 'fr_FR',
        menubar: false
      });
    },

    popin: function() {
      $("#left").stick_in_parent({offset_top: 20});

      $(".login-popin, .popin-dash").colorbox({
        speed: 200
      });

      $.each( $(".popin-inline"), function() {
        $(this).colorbox({
          inline: true,
          href: $(this).attr('href')
        });
      });

    },

    upload: function() {
      var percent = 0;
      var spinner_path = "/static/images/show-avatar-loading.gif";
      var img = $('.js-preview-img img').first();
      var original_src = img.attr('src');

      var $el = $('.cloudinary-fileupload');

      var failed = function(e, data) {
        img.attr('src', original_src);
        alert("Une erreur s'est produite lors de l'envoi de votre photo, veuillez réessayer.");
      };

      // $el.bind('fileuploadprogress', function(e, data) {
        // percent = Math.round((data.loaded * 100.0) / data.total);
        // $('.progress_bar').css('width', percent + '%');
      // });

      $el.bind('cloudinarystart', function(e, data) {
        img.attr('src', spinner_path);
      });

      $el.fileupload('option', {
          maxFileSize: 5000000, // Maximum File Size in Bytes - 5 MB
          minFileSize: 1000, // Minimum File Size in Bytes - 1 KB
          maxNumberOfFiles: 1,
          acceptFileTypes: /(png)|(jpeg)|(jpg)|(gif)$/i  // Allowed File Types
      });

      $el.bind('fileuploadstopped', failed);
      $el.bind('cloudinaryfail', failed);

      $el.bind('cloudinarydone', function(e, data) {

        var expert_id = $('#expert_id').first().val();

        $.ajax({
          type: "POST",
          url: "/experts/" + expert_id + "/photo",
          data: {img: data.result},
          headers: {
            'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
          },
          success: function() {
            $('.js-preview-img').html(
              $.cloudinary.image(data.result.public_id,
                { format: data.result.format, version: data.result.version,
                  crop: 'fill', width: 140, height: 140 })
            );
          }
        });

        return true;
      });
    },

    upcfirst: function() {
      function ucfirst(str,force){
        str=force ? str.toLowerCase() : str;
        return str.replace(/(\b)([a-zA-Z])/,
          function(firstLetter){
            return   firstLetter.toUpperCase();
          });
        }

      $('.input-uppercase').keyup(function(evt){

        // force: true to lower case all letter except first
        var cp_value= ucfirst($(this).val(),true) ;

        // to capitalize all words
        //var cp_value= ucwords($(this).val(),true) ;

        $(this).val(cp_value );

      });
    }

};
