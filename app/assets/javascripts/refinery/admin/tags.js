$(document).ready(function() {
    $(".tag-list").on("click", ".tag-name", function(event) {
        $(this).hide();
        $(this).next(".edit-tag-name").show();
        $(this).next(".edit-tag-name").focus();
    });
    $(".tag-list").on("keydown", ".edit-tag-name", function(event) {
        if (event.keyCode == 27) {
            $(this).prev(".tag-name").show();
            $(this).text($.trim($(this).prev(".tag-name").text()));
            $(this).hide();
        }
        if (event.keyCode == 13) {
            newName = $.trim($(this).text());
            oldName = $.trim($(this).prev(".tag-name").text());
            if (newName != oldName) {
                content = $(this);
                $.ajax({
                    type: 'PUT',
                    url: '/refinery/tags/' + content.attr('data-id'),
                    data: {id: content.attr('data-id'), new_name: newName},
                    success: function(data, status) {
                        if (data.status == "ok") {
                            content.prev(".tag-name").text(newName);
                        }
                    },
                    error: function (response) {
                        alert(response);
                    }
                });
            } else {
                $(this).text(oldName);
            }
            $(this).prev(".tag-name").show();
            $(this).hide();
        }
    });
    $(".tag-list").on("blur", ".edit-tag-name", function(event) {
        $(this).prev(".tag-name").show();
        $(this).hide();
    });
});
