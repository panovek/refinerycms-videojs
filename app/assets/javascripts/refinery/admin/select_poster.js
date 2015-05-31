$(document).ready(function() {
    $(".poster-example").on("click", function(event) {
        $(".poster-example").removeClass("selected-poster");
        $(this).addClass("selected-poster");
        $("#selected_poster_example_time").val($(this).attr("data-second"));
    });
});
