window.onload = function ()
{
    if ($('video').is('*')) {
        $('body').append('<link href="//vjs.zencdn.net/4.8/video-js.css" rel="stylesheet">')
        $('body').append('<script src="//vjs.zencdn.net/4.8/video.js"></script>')
    }
};