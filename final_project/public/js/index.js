// External js being loaded - https://cdnjs.cloudflare.com/ajax/libs/waypoints/2.0.5/waypoints.min.js
$(function() {
    waypoints.init();
})

var waypoints = {
    init: function() {
        // container - used for toggling classes to animate content
        this.container = $('html');

        // header - main header container: an inner wrapper element should get fixed (.header-bar)
        this.header = $('[data-animate-header-container]');

        // headerHeight - the inner header element that gets fixed
        this.headerHeight = $('[data-animate-header]').outerHeight();

        // targetElement - when this element hits top of screen the header  animates
        this.targetElement = $('[data-animate-header-target]');

        // bindControls
        this.bindControls();
    },
    animateHeader: function() {
        var self = this;

        // Add class when header is in/out of view
        self.header.waypoint(function(direction) {
            if (direction === "up") {
                self.container.removeClass('header-past header-hide');
            } else {
                self.container.addClass('header-past');
            }
        }, { offset: -self.headerHeight });

        // Animate header in when this element hits top of screen
        self.targetElement.waypoint(function(direction) {
            if (direction === "up") {
                self.container.addClass('header-hide').removeClass('header-show');
            } else {
                self.container.addClass('header-show').removeClass('header-hide');
            }
        }, { offset: 0 });
    },
    bindControls: function () {
        var self = this;

        self.animateHeader();
    },
}