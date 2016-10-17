$( document ).ready(function() {
    $('a[href="' + this.location.pathname + '"]').parents('li,ul').addClass('active');
});