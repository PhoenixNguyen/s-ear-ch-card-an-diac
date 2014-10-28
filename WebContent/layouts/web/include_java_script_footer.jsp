<%@ page language="java" trimDirectiveWhitespaces="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script type="text/javascript">
/*<![CDATA[*/
/* jQuery(function($) {

$(function(){
	$('#hot_productslides').slides({
		preload: true,
		preloadImage: 'images/loading.gif',
		play: 5000,
		pause: 2500,
		hoverPause: true
	});
});

}); */

$(function() {
    $('#hot_productslides').slidesjs({
      width: 550,
      height: 350,
      navigation: false,
      start: 3,
      play: {
        auto: true
      }
    });
  });
/*]]>*/
</script>
<!-- Create Menu Settings: (Menu ID, Is Vertical, Show Timer, Hide Timer, On Click ('all' or 'lev2'), Right to Left, Horizontal Subs, Flush Left, Flush Top) -->
<script type="text/javascript">qm_create(0,false,0,250,false,false,false,false,false);</script>

<!-- SlidesJS Optional: If you'd like to use this design -->
<style>
  .slidesjs-navigation {
    margin-top:3px;
  }

  .slidesjs-previous {
    margin-right: 5px;
    float: left;
  }

  .slidesjs-next {
    margin-right: 5px;
    float: left;
  }

  .slidesjs-pagination {
    margin: 6px 0 0;
    /* float: right; */
    display: inline-block;
    list-style: none;
  }

  .slidesjs-pagination li {
    float: left;
    margin: 0 1px;
  }

  .slidesjs-pagination li a {
    display: block;
    width: 13px;
    height: 0;
    padding-top: 13px;
    background-image: url(images/pagination.png);
    background-position: 0 0;
    float: left;
    overflow: hidden;
  }

  .slidesjs-pagination li a.active,
  .slidesjs-pagination li a:hover.active {
    background-position: 0 -13px
  }

  .slidesjs-pagination li a:hover {
    background-position: 0 -26px
  }

  /* a:link,
  a:visited {
    color: #333
  }

  a:hover,
  a:active {
    color: #9e2020
  } */

  .navbar {
    overflow: hidden
  }
</style>
  <!-- End SlidesJS Optional-->