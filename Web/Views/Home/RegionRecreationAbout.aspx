<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/ArticleView.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Достопримечательность: <%= ViewData["RecreationName"]%>. <%= ViewData["RegionName"]%>, <%= ViewData["CountryName"] %>.
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" charset="utf-8">
        $.fn.infiniteCarousel = function () {

            function repeat(str, num) {
                return new Array(num + 1).join(str);
            }
            return this.each(function () {
                var $wrapper = $('> div', this).css('overflow', 'hidden'),
				$slider = $wrapper.find('> ul'),
				$items = $slider.find('> li'),
				$single = $items.filter(':first'),

				singleWidth = $single.outerWidth(),
				visible = Math.ceil($wrapper.innerWidth() / singleWidth), // note: doesn't include padding or border
				currentPage = 1,
				pages = Math.ceil($items.length / visible);


                // 1. Pad so that 'visible' number will always be seen, otherwise create empty items
                if (($items.length % visible) != 0) {
                    $slider.append(repeat('<li class="empty" />', visible - ($items.length % visible)));
                    $items = $slider.find('> li');
                }

                // 2. Top and tail the list with 'visible' number of items, top has the last section, and tail has the first
                $items.filter(':first').before($items.slice(-visible).clone().addClass('cloned'));
                $items.filter(':last').after($items.slice(0, visible).clone().addClass('cloned'));
                $items = $slider.find('> li'); // reselect

                // 3. Set the left position to the first 'real' item
                $wrapper.scrollLeft(singleWidth * visible);

                // 4. paging function
                function gotoPage(page) {
                    var dir = page < currentPage ? -1 : 1,
					n = Math.abs(currentPage - page),
					left = singleWidth * dir * visible * n;

                    $wrapper.filter(':not(:animated)').animate({
                        scrollLeft: '+=' + left
                    }, 500, function () {
                        if (page == 0) {
                            $wrapper.scrollLeft(singleWidth * visible * pages);
                            page = pages;
                        } else if (page > pages) {
                            $wrapper.scrollLeft(singleWidth * visible);
                            // reset back to start position
                            page = 1;
                        }

                        currentPage = page;
                    });

                    return false;
                }

                $wrapper.after('<a class="arrow back">&lt;</a><a class="arrow forward">&gt;</a>');

                // 5. Bind to the forward and back buttons
                $('a.back', this).click(function () {
                    return gotoPage(currentPage - 1);
                });

                $('a.forward', this).click(function () {
                    return gotoPage(currentPage + 1);
                });

                // create a public interface to move to a specific page
                $(this).bind('goto', function (event, page) {
                    gotoPage(page);
                });
            });
        };

        $(document).ready(function () {
            $('.infiniteCarousel').infiniteCarousel();
            $("area[rel^='prettyPhoto']").prettyPhoto();
            $(".gallery:first a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'normal', theme: 'light_square', slideshow: 10000, autoplay_slideshow: true });
            $(".gallery:gt(0) a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'fast', slideshow: 10000, hideflash: true });

        });
    </script>
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a>
    </div>
    <h2>Достопримечательность: <%= ViewData["RecreationName"]%>. <%= ViewData["RegionName"]%>, <%= ViewData["CountryName"].ToString().TrimEnd() + "." %></h2>
    <br />
    <div class="infoContentSection" style="margin-top: -20px;">
        <%= ViewData["Description"] %>
    </div>
    <br /><br />
    <%List<LinqToElcondor.TblPhotoImage> items = ElcondorBiz.BizRegionRecreation.GetRecreationImageGallery(int.Parse(ViewData["RegionRecreationId"].ToString()));
                    if (items.Count > 0) { %>
        <h3>Фотоальбомы: <%= ViewData["RecreationName"]%>, <%= ViewData["CountryName"] %></h3>
		<div style="width:740px;margin-bottom: 20px;">
            <h4 style="float:left;"></h4>
			<br/>
            
			<div style="width:720px;height:120px;margin:10px 10px;">
				<div class="infiniteCarousel">
					<div class="wrapper">
						<ul class="gallery clearfix">
                            <%
                                StringBuilder sb = new StringBuilder();
                                
                                foreach (LinqToElcondor.TblPhotoImage img in items) {
                                    sb.Append(string.Format("<li><a href=\"../../Content/UserImages/recreation_{0}_image_{1}.jpg\" rel=\"prettyPhoto[pp_gal]\" title=\"{2}\"><img src=\"../../Content/UserImages/recreation_{0}_image_{1}.jpg\" alt=\"\" height=\"100px\" ></a></li>"
                                                                , img.PhotoalbumId, img.Id, img.Description));
                                }
                                
                            %>
							<%= sb.ToString() %>
                        </ul>
					</div>
				</div>
			</div>
		</div>
        <% } %>
    <br /><br />
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a>
    </div>
</asp:Content>
