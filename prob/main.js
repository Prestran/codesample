$(document).ready( () => {
    $(document).on ("change", ".js-register-first, .js-register-last, .js-register-username", (event) => {
        let generated_username = $('.js-register-first').val().toString() + "-" + $('.js-register-last').val().toString();
        generated_username.replace(/ /g,'');

        // ajax request to check if username given is available
        $.ajax({
            url: $('.new_user').data('urlusername'),
            dataType: 'json',
            data: { username: generated_username },
            success: (xhr) => {
                // add green border if username can be taken
                $('.js-username-error').remove();
                $('.js-register-username').removeClass('red-border');
                $('.js-register-username').addClass('green-border');
            },
            error: (xhr) => {
                // add red border if username can not be taken
                $('.js-username-error').remove();
                $('.js-register-username').addClass('red-border');
                _error = $("<small />", { class: "form-text red-text js-username-error", html: `${xhr.responseJSON.message}` });
                $('.js-register-username').parents('.form-group').append(_error);
            }
        });
        $('.js-register-username').val(generated_username);
    })
})