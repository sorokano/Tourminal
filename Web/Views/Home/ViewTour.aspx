<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/TourView.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <%= ViewData["CountryName"] %>
    - Просмотр маршрута:
    <%= ViewData["TourName"] %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(function () {
            $("#datefrom").datepicker($.datepicker.regional['ru']);
            $("#dateto").datepicker($.datepicker.regional['ru']);
        });
        ddsmoothmenu.init({
            mainmenuid: "menutour", //menu DIV id
            orientation: 'h', //Horizontal or vertical menu: Set to "h" or "v"
            classname: 'ddsmoothmenu-tour', //class added to menu's outer DIV
            //customtheme: ["#1c5a80", "#18374a"],
            contentsource: "markup" //"markup" or ["container_id", "path_to_menu_file"]
        })

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
                if (($items.length % visible) != 0) {
                    $slider.append(repeat('<li class="empty" />', visible - ($items.length % visible)));
                    $items = $slider.find('> li');
                }
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
                $('a.back', this).click(function () {
                    return gotoPage(currentPage - 1);
                });
                $('a.forward', this).click(function () {
                    return gotoPage(currentPage + 1);
                });
                $(this).bind('goto', function (event, page) {
                    gotoPage(page);
                });
            });
        };

        $(document).ready(function () {
            $("#btnbook").click(function () {                
                $('#lblTourname').text('<%= ViewData["TourName"] %>');
                $('#itemId').val('<%= ViewData["TourId"] %>');
                $('#itemName').val('<%= ViewData["TourName"] %>');
                $('#txtDlgItemName').val("");
                $('#dialog-book').dialog('open');
            });
            $("#hrefTourRoute").click(function () {
                $("#hrefTourRoute").addClass('selected');
                $("#hrefTourProgram").removeClass('selected');
                $("#hrefTourPhoto").removeClass('selected');
            });
            $("#hrefTourProgram").click(function () {
                $("#hrefTourRoute").removeClass('selected');
                $("#hrefTourProgram").addClass('selected');
                $("#hrefTourPhoto").removeClass('selected');
            });
            $("#hrefTourPhoto").click(function () {
                $("#hrefTourRoute").removeClass('selected');
                $("#hrefTourProgram").removeClass('selected');
                $("#hrefTourPhoto").addClass('selected');
            });
            $("#hrefTourRoute").addClass('selected');
            $("#divTourInfo").show();
            $("#divTourProgram").hide();
            $("#divTourPhoto").hide();

            $("#hrefTourRoute").click(function () {
                $("#divTourInfo").show();
                $("#divTourProgram").hide();
                $("#divTourPhoto").hide();
            });
            $("#hrefTourProgram").click(function () {
                $("#divTourInfo").hide();
                $("#divTourProgram").show();
                $("#divTourPhoto").hide();
            });
            $("#hrefTourPhoto").click(function () {
                $("#divTourInfo").hide();
                $("#divTourProgram").hide();
                $("#divTourPhoto").show();
            });

            $('.infiniteCarousel').infiniteCarousel();
            $("area[rel^='prettyPhoto']").prettyPhoto();
            $(".gallery:first a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'normal', theme: 'light_square', slideshow: 10000, autoplay_slideshow: true });
            $(".gallery:gt(0) a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'fast', slideshow: 10000, hideflash: true });
            $("#dialog-book").dialog({
                autoOpen: false,
                resizable: false,
                height: 640,
                width: 720,
                modal: true,
                title: 'Подтвердите бронирование тура',
                buttons: {
                    'Закрыть': function () {
                        $(this).dialog('close');
                    }
                },
                close: function () {
                    //$('#txtDlgItemId').val("");
                    //$('#txtDlgTagSize').val("");
                    //location.reload();
                }
            });
        });
    </script>
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>">
            <%=ViewData["CountryName"] %></a>
        <% 
            LinqToElcondor.TblTour tour = ElcondorBiz.BizTour.GetTourById(int.Parse(ViewData["TourId"].ToString()));
            if (tour.IsCruise.Value) {%>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryCruises?id=<%= ViewData["CountryId"]%>">Все круизы</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["TourName"] %>
        <% } else if (tour.IsExcursion.Value) {%>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryExcurs?id=<%= ViewData["CountryId"]%>">Все экскурсии</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["TourName"]%>
        <% } else { %>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryTours?id=<%= ViewData["CountryId"]%>">Все маршруты</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["TourName"]%>
        <% } %>
    </div>
    <div id="menutour" class="ddsmoothmenu-tour">
        <ul>
            <li><a href="#" id="hrefTourRoute">Маршрут</a></li>
            <li><a href="#" id="hrefTourProgram">Программа</a></li>
            <% if (int.Parse(ViewData["PhotoCount"].ToString()) > 0) { %>
            <li><a href="#" id="hrefTourPhoto">Фотогалерея (<%= ViewData["PhotoCount"]%>)</a></li>
            <% } %>
        </ul>
        <ul id="tourprice">
            <li><a>Цена: <span style="color: #000; font-weight: bold;">
                <%= ViewData["TourPrice"] != null && ViewData["TourPrice"].ToString() !="0" ? ViewData["TourPrice"].ToString() + " руб" : "не указана"%>
                </span></a></li>
        </ul>
    </div>
    <br />
    <h1>
        <%= ViewData["CountryName"] %>
        <% if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %>
        <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;
            vertical-align: middle;" />
        <% } %>
        <span style="font-size: 22px; font-weight: normal;">
            <%= ViewData["TourName"] %></span></h1>
    <div style="margin-bottom: 30px; padding-top: 20px;">
        <div style="margin-top: -20px;" id="divTourInfo">
            <%= ViewData["TourDescription"] %>
        </div>
        <div style="margin-top: -20px;" id="divTourProgram">
            <%= ViewData["TourProgram"] %>
        </div>
        <div style="margin-top: -20px;" id="divTourPhoto">
            <%List<LinqToElcondor.TblPhotoImage> items = ElcondorBiz.BizTour.GetImageGallery(int.Parse(ViewData["TourId"].ToString()));
              if (items.Count > 0) { %>
            <h3>
                Фотоальбомы:
                <%= ViewData["TourName"] %>,
                <%= ViewData["CountryName"] %></h3>
            <div style="width: 740px; margin-bottom: 20px;">
                <h4 style="float: left;">
                </h4>
                <br />
                <div style="width: 720px; height: 120px; margin: 10px 10px;">
                    <div class="infiniteCarousel">
                        <div class="wrapper">
                            <ul class="gallery clearfix">
                                <%
                StringBuilder sb = new StringBuilder();

                foreach (LinqToElcondor.TblPhotoImage img in items) {
                    sb.Append(string.Format("<li><a href=\"../../Content/UserImages/tour_{0}_image_{1}.jpg\" rel=\"prettyPhoto[pp_gal]\" title=\"{2}\"><img src=\"../../Content/UserImages/tour_{0}_image_{1}.jpg\" alt=\"\" height=\"100px\" ></a></li>"
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
            <div id="blankspace">
            </div>
        </div>
    </div>
    <br />
    <br />
    <div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>">
            <%=ViewData["CountryName"] %></a>
        <% 
            if (tour.IsCruise.Value) {%>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryCruises?id=<%= ViewData["CountryId"]%>">Все круизы</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["TourName"] %>
        <% } else if (tour.IsExcursion.Value) {%>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryExcurs?id=<%= ViewData["CountryId"]%>">Все экскурсии</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["TourName"]%>
        <% } else { %>
        <img src="../../Content/Images/greenarrow.png" />
        <a href="../../CountryTours?id=<%= ViewData["CountryId"]%>">Все маршруты</a>
        <img src="../../Content/Images/greenarrow.png" />
        <%= ViewData["TourName"]%>
        <% } %>
    </div>
    <br />
    <br />
    <div id="dialog-book">
        <%--<% using (Html.BeginForm("SendTourBookMessage", "Home", FormMethod.Post, new { autocomplete = "off" })) { %>--%>
        <form method="post" id="msgForm" style="margin: 0 auto;" action="verifyRegistration.php">
        <h2>
            <label id="lblTourname">
            </label>
        </h2>
        <div id="errorContact" class="error">&nbsp;</div>
        <table class="tblsimple">
            <tr>
                <td>
                    Ваше имя:
                </td>
                <td>
                    <div class="input-container">
                        <input name="nameContact" id="nameContact" type="text" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Ваш контактный Email:
                </td>
                <td>
                    <div class="input-container">
                        <input name="emailContact" id="emailContact" type="text" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Предполагаемые даты поездки:
                </td>
                <td>
                    с
                    <%= Html.TextBox("datefrom", string.Empty, new { style = "width:100px" })%>
                    по
                    <%= Html.TextBox("dateto", string.Empty, new { style = "width:100px" })%>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span style="color: #000; margin-bottom: 5px;">Присоединить сообщение:</span><br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="input-container">
                        <textarea name="contentContact" id="contentContact" rows="5" cols="70"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <span style="color: #000; margin-bottom: 5px;">Введите текст на картинке:</span><br />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="captchaitm">
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" id="btnsubmit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" style="float: right;" value="Отправить сообщение" />
                    <img id="loading" src="../../Content/Images/ajax-wait.gif" alt="working.." style="float: right;
                        margin-right: 5px; padding-top: 2px;" />
                </td>
            </tr>
        </table>
        <input name="itemId" id="itemId" type="text" style="display: none;" />
        <input name="itemName" id="itemName" type="text" style="display: none;" />
        <%-- <br />
             <br />--%>
        <%--<%= Html.TextArea("txtDlgMessage", string.Empty, 5, 55, new { name = "txtDlgMessage" })%>
            </fieldset>--%>
        <%--<%= Html.TextBox("txtDlgItemId", string.Empty, new { style = "visibility:hidden; width:50px" })%>--%>
        <%--<br /><br />--%>
        <%--<input type="submit" value="Подтвердить бронирование" id="btnSave" name="btnEditItem" value="edititem" />--%>
        <%--<button class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" type="button" role="button" aria-disabled="false">
                <span class="ui-button-text">Подтвердить бронирование</span>
            </button>--%>
        </form>
        
    </div>
</asp:Content>
