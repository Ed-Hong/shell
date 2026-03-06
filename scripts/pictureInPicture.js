// script to play a video in Chrome using picture-in-picture mode
// this selects the <video> element within a <div> with class `video-player__container` ie:
// <div class="video-player__container">
//     <video>
// </div>

// Twitch:
javascript:document.querySelector('div.video-player__container video').requestPictureInPicture();void(0);

// Youtube:
javascript:document.querySelector('div.html5-video-container video').requestPictureInPicture();void(0);
