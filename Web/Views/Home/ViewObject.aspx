<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Rent.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Отель <%= ViewData["HotelName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../../Scripts/gmap3.js"></script>
    <%--<div class="content">--%>
    <script type="text/javascript" charset="utf-8">            
        $(document).ready(function () {			
            hideshow('loading', 0);	
            $("#datefrom").datepicker($.datepicker.regional['ru']);
            $("#dateto").datepicker($.datepicker.regional['ru']);
            $('#datefrom').val($.query.get("datefrom"));
            $('#dateto').val($.query.get("dateto"));
            $('#contentContact').val("Взрослых: " + $.query.get("adults") + ", детей: " + $.query.get("kids"));            
            //MAP START
            function displayPoint(marker, data, map) {
	            var scale = Math.pow(2, map.getZoom());
	            var nw = new google.maps.LatLng(
                    map.getBounds().getNorthEast().lat(),
                    map.getBounds().getSouthWest().lng());

	            var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
	            var worldCoordinate = map.getProjection().fromLatLngToPoint(marker.getPosition());

	            var pixelOffset = new google.maps.Point(
                    Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
                    Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
                );
	            $("#message").html(data);
	            $("#message").show().css({ top: pixelOffset.y, left: pixelOffset.x });
	        }
            if ("<%= ViewData["HotelLatLng"].ToString()%>" == "[0,0]" ) { 
                $('#hrefMap').hide();
            }
            //MAP END
            carouselInstance = $("#carousel-gallery").touchCarousel({				
			    itemsPerPage: 1,				
			    scrollbar: true,
			    scrollbarAutoHide: true,
			    scrollbarTheme: "dark",				
			    pagingNav: false,
			    snapToItems: false,
			    scrollToLast: true,
			    useWebkit3d: true,				
			    loopItems: false
		    }).data('touchCarousel');			
                
            $("area[rel^='prettyPhoto']").prettyPhoto();
            $(".gallery:first a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'normal', theme: 'light_square', slideshow: 10000, autoplay_slideshow: true });
            $(".gallery:gt(0) a[rel^='prettyPhoto']").prettyPhoto({ animation_speed: 'fast', slideshow: 10000, hideflash: true });
                	
            $("#hrefPhotos").addClass('selected');
            $("#divPhotos").show();
            $("#divMap").hide();
            $("#hrefPhotos").click(function () {
                $("#hrefPhotos").addClass('selected');
                $("#hrefMap").removeClass('selected');
                $("#divPhotos").show();
                $("#divMap").hide();
            });
            $("#hrefMap").click(function () {
                $("#hrefMap").addClass('selected');
                $("#hrefPhotos").removeClass('selected');
                $("#divMap").show();
                $("#divPhotos").hide();
                $('#hotelmap').gmap3(
                    { action: 'init',
                        options: {
                            center: <%= ViewData["HotelLatLng"]%>,
                            mapTypeId: google.maps.MapTypeId.ROADMAP,
                            zoom: 15,
                            mapTypeControl:true,
                            mapTypeControlOptions: {
                                style:google.maps.MapTypeControlStyle.DROPDOWN_MENU,
                                position:google.maps.ControlPosition.RIGHT_CENTER
                            },
                            zoomControl: true,
                            zoomControlOptions: {
                                style: google.maps.ZoomControlStyle.SMALL,
                                position: google.maps.ControlPosition.LEFT_CENTER
                            }
                        }
                    },
                    { action: 'addMarkers',
                        markers: [
                    <%= ViewData["MarkersHTML"] %>
                    ],
                        marker: {
                            options: {
                                draggable: false
                            },
                            events: {
                                mouseover: function (marker, event, data) {
                                    var map = $(this).gmap3('get');
                                    displayPoint(marker, data.content, map);
                                },
                                mouseout: function () {
                                    $("#message").delay(15000).fadeOut(800);
                                },
                                click: function (marker, event, data) {
                                    location.href = data.weblink_text;
                                },
                            }
                        }
                    }
                );
            });            
            $('#explain1').click(function () {
                $("#sec1part2").show();
                $('#explain1').hide();
            });
            $('#sec1part2').click(function () {
                $('#sec1part2').hide();
                $("#explain1").show();
            });
//                
//                $('#mycarousel').jcarousel({
//                    size: mycarousel_itemList.length,
//                    scroll: 4,
//                    itemLoadCallback: { onBeforeAnimation: mycarousel_itemLoadCallback }
//                });
            function mycarousel_itemLoadCallback(b) {
                for (var a = b.first; a <= b.last; a++) {
                    if (b.has(a)) continue;
                    if (a > mycarousel_itemList.length) break;
                    b.add(a, mycarousel_getItemHTML(mycarousel_itemList[a - 1]))
                }
            }
            //function mycarousel_getItemHTML(a) { var b = '<a class="lightboxa" href="'+a.url+'"><img " src="' + a.url + '" width="47" height="38" alt="' + a.title + '" tooltip="' + a.title + '" onMouseOver="changePicture(' + a.count + ', true)" style="margin-bottom:5px;" /></a>'; if (a.urlTwo.length > 0) b += '<img src="' + a.urlTwo + '" width="47" height="38" alt="' + a.titleTwo + '" tooltip="' + a.titleTwo + '" onMouseOver="changePicture(' + a.countTwo + ', false)" />'; return b } function changePicture(d, c) { var a = document.getElementById(imgPictureBoxChangerId), b = mycarousel_itemList[d - 1]; if (c) { a.src = b.url; a.height = b.imageHeight; a.style.height = b.imageHeight + "px"; a.width = b.imageWidth; a.style.width = b.imageWidth + "px"; a.tooltip = b.title; a.alt = b.title } else { a.src = b.urlTwo; a.height = b.imageHeightTwo; a.style.height = b.imageHeightTwo + "px"; a.width = b.imageWidthTwo; a.style.width = b.imageWidthTwo + "px"; a.tooltip = b.titleTwo; a.alt = b.titleTwo } }
                
            //$('a.lightboxa').lightBox();

            $("#btnbook").click(function () {
                location.href = "../../HotelBooking?id=<%= ViewData["HotelId"] %>&datefrom=" + $.query.get("datefrom") + "&dateto=" + $.query.get("dateto") 
                                + "&adults=" + $.query.get("adults") + "&kids=" + $.query.get("kids");
//                $('#lblHotelname').text('<%= ViewData["HotelName"] %>');
//                $('#itemId').val('<%= ViewData["HotelId"] %>');
//                $('#itemName').val('<%= ViewData["HotelName"] %>');
//                $('#txtDlgItemName').val("");
//                $('#dialog-book').dialog('open');
            });
            $("#dialog-book").dialog({
                autoOpen: false,
                resizable: false,
                height: 600,
                width: 520,
                modal: true,
                title: 'Подтвердите бронирование отеля',
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

    <%--Основной контент--%>
    <div style="width: 100%;padding-left:10px;margin:10px 0 10px 0;display:block;">
        <div style="width: 100%;margin-bottom:15px;">
            <%if (Session["SearchResultQuery"] != null) { %><a class="btnpink" href="<%= Session["SearchResultQuery"].ToString() %>">Вернуться к результатам поиска</a><% } %>
        </div>
        <div style="width: 400px;float:left;">
            <div style="font-size: 28px;width:400px;display: block;float:left;">                
                <div style="width:100%;">
                    <% StringBuilder sb5 = new StringBuilder();
                    int starRating = ViewData["HotelStarRating"] != null ? int.Parse(ViewData["HotelStarRating"].ToString()) : 0;
                    if (starRating > 0) {
                        sb5.Append("<span class=\"star-rating-control\"><div class=\"rating-cancel\" style=\"display: none;\"></div>");
                        for (int i = 1; i < 6; i++) {
                            if (starRating >= i)
                                sb5.Append("                     <div class=\"star-rating rater-0 star star-rating-applied star-rating-readonly star-rating-on\"><a title=\"on\">on</a></div>");
                            else
                                sb5.Append("                     <div class=\"star-rating rater-0 star star-rating-applied star-rating-readonly\"><a title=\"on\">on</a></div>");
                        }
                        sb5.Append("                         </span>");
                    }%>
                    <%= sb5.ToString() %>
                 </div> 
                <div style="width:100%;">
                    <%= ViewData["HotelName"] %>&nbsp;
                </div>
                <div style="width:100%;font-size:14px;margin-bottom:10px;">
                    <%= ViewData["HotelAddress"] %><br /><%= ViewData["HotelCityIName"]%>, <%= ViewData["HotelCountryName"]%>
                </div>
            </div>
            <%--<div style="width:380px;display: block;font-size:14px;float:left;">
                <a href="<%= ViewData["UrlBackToSearch"] %>"><%= ViewData["HotelAddress"] %></a>
            </div>--%>
        </div>
        <div style="width:120px;display: block;font-size:20px;float:left;">
            <div style="width:100%;display: block;float:left;color:#b1b4b6;">
                от <span style="font-size:22px;color:#000;font-weight:bolder;"><%= ViewData["HotelMinPricePerPerson"]%> €</span>
            </div>
            <div style="width:100%;display: block;float:left;color:#b1b4b6;">
                за сутки
            </div>
        </div>
        <div style="float:right;width:120px;margin-left:10px;">
            <a href="#" id="btnbook" class="btnview">Забронировать<%--<img src="../../Content/Images/btnbook2.jpg" alt="" />--%></a>
        </div>
    </div>
    <br />
    <div style="width: 680px;margin-top:50px;margin-left:-12px;">
        <% if (int.Parse(ViewData["HotelImageCount"].ToString()) > 0) { %>
        <div id="divPhotos" class="hotel-tab">
            <div id="carousel-gallery" class="touchcarousel  black-and-white">  
                <ul class="touchcarousel-container">
		            <%= ViewData["HotelImageList"]%>			
	            </ul>
            </div>
            
            <div>
                <ul class="hotel-thumbs gallery clearfix"">                        
                    <%= ViewData["HotelThumbImageList"]%>			
                </ul>
            </div>
        </div>
        <% } %>
        <div id="divMap" class="hotel-tab">
            <div id="hotelmap"></div>
        </div>
        <div id="menuhotel" class="ddsmoothmenu-tour">
            <ul>
                <% if (int.Parse(ViewData["HotelImageCount"].ToString()) > 0) { %><li><a href="#" id="hrefPhotos">Фотогалерея</a></li><% } %>
                <li><a href="#" id="hrefMap">Карта</a></li>
            </ul>
        </div>
    </div>
    <div style="width: 100%;padding-left:10px;margin-top:5px;">
        <div id="divResultPanel">
            <div id="divSearchResult">
                <%--<%= ViewData["PageContent"] %>--%>
                <%--<%=  ViewData["SearchResultsGrid"]%>
                <ul>
                    
                </ul>--%>
                <!-- OBJECT DESCRIPTION START-->
                <h1>Расположение</h1>
                <p>
                    <% if(ViewData["HotelAddress"] != null) { %>
                        <%= ViewData["HotelAddress"] + ","%> 
                    <% } %>
                    <%= ViewData["HotelCityIName"]%> (<%= ViewData["HotelDistrictName"]%>), <%= ViewData["HotelCountryName"]%>.
                </p>
                <br />
                <h1>В отеле</h1>
                <p>
                    <%= ViewData["HotelDescription"]%>
                </p>
                <% List<TaratripLinq.TblHotelRoom> l8 = TaratripBiz.BizHotelRoom.GetHotelRoomList(int.Parse(ViewData["HotelId"].ToString()));
                     %>
                <br />
                <% if (ViewData["txtAddDesc"] != null) { %>
                <h1>Описание номеров</h1>
                <p>
                    <%= ViewData["txtAddDesc"].ToString()%>
                </p>
                <% } %>
                <hr style="color:#ccc;"/>                    
                    <% StringBuilder sb3 = new StringBuilder();
                    List<TaratripLinq.TblHotelAmenity> l1 = TaratripBiz.BizHotel.GetHotelAmenities(int.Parse(ViewData["HotelId"].ToString()));
                    List<TaratripLinq.TblHotelService> l2 = TaratripBiz.BizHotel.GetHotelServices(int.Parse(ViewData["HotelId"].ToString()));
                    List<TaratripBiz.Model.TblHotelGoodForPersonView> l3 = TaratripBiz.BizHotel.GetHotelGoodForPersonView(int.Parse(ViewData["HotelId"].ToString()));

                    List<TaratripLinq.TblHotelForKids> l4 = TaratripBiz.BizHotel.GetHotelForKids(int.Parse(ViewData["HotelId"].ToString()));
                    List<TaratripLinq.TblHotelSport> l5 = TaratripBiz.BizHotel.GetHotelSports(int.Parse(ViewData["HotelId"].ToString()));
                    List<TaratripLinq.TblHotelHealth> l6 = TaratripBiz.BizHotel.GetHotelHealths(int.Parse(ViewData["HotelId"].ToString()));
                    List<TaratripLinq.TblHotelRestaurant> l7 = TaratripBiz.BizHotel.GetHotelRestaurants(int.Parse(ViewData["HotelId"].ToString()));%>
                    <% if (!(l1.Count == 0 && l2.Count == 0 && l3.Count == 0 && l4.Count == 0 && l5.Count == 0 && l6.Count == 0 && l7.Count == 0)) {%>
                    <p>
                        <span style="color:#bbb;font-size:30px;font-weight:bolder;">Дополнительная информация об отеле</span>
                    </p>
                    <%if (l1.Count > 0) { %>
                    <h3>Сервис и удобства</h3>
                    <p>
                        <%int i = 0;
                          sb3.Append("<ul style=\"margin:0;padding:0;\">");
                          foreach (TaratripLinq.TblHotelAmenity ha in l1) {
                              sb3.Append(string.Format("<li style=\"list-style:none;\">- {0}</li>", ha.Description));//, i == l1.Count - 1 ? "<br/><br/>" : ", "));
                              i++;
                          }

                          foreach (TaratripLinq.TblHotelService srv in l2) {
                              sb3.Append(string.Format("<li style=\"list-style:none;\">- {0}</li>", srv.Description));//, i == l2.Count - 1 ? "<br/><br/>" : ", "));
                              i++;
                          }
                          sb3.Append("</ul>");%>
                        <%= sb3.ToString()%>
                    </p>
                    <%} %>

                     <% if (l6.Count > 0) {
                            int i = 0;%>
                        <h3>Медицина, здоровье и красота:</h3>
                            <% sb3 = new StringBuilder();
                               sb3.Append("<ul style=\"margin:0;padding:0;\">");
                               foreach (TaratripLinq.TblHotelHealth gfp in l6) {
                                   sb3.Append(string.Format("<li style=\"list-style:none;\">- {0}</li>", gfp.Description));//, i == l2.Count - 1 ? "<br/><br/>" : ", "));
                                   i++;
                               }
                               sb3.Append("</ul>");%>
                            <%= sb3.ToString()%>                            
                    <% } %>
                    <% if (l4.Count > 0) {
                           int i = 0;%>
                        <h3>Для детей:</h3>
                            <% sb3 = new StringBuilder();
                               sb3.Append("<ul style=\"margin:0;padding:0;\">");
                               foreach (TaratripLinq.TblHotelForKids gfp in l4) {
                                   sb3.Append(string.Format("<li style=\"list-style:none;\">- {0}</li>", gfp.Description));//, i == l2.Count - 1 ? "<br/><br/>" : ", "));
                                   i++;
                               }
                               sb3.Append("</ul>");%>
                            <%= sb3.ToString()%>   
                    <% } %>
                    <% if (l7.Count > 0) {
                           int i = 0;%>
                    <h3>Бары и рестораны:</h3>
                    <p>
                        <% sb3 = new StringBuilder();
                           foreach (TaratripLinq.TblHotelRestaurant gfp in l7) {
                               sb3.Append(string.Format("{0}{1}", gfp.Description, i == l7.Count - 1 ? "<br/><br/>" : ", "));
                               i++;
                           } %>
                        <%= sb3.ToString()%>  
                    </p>
                    <% } %>
                     <% if (l5.Count > 0) {
                            int i = 0;%>
                        <h3>Спорт и развлечения:</h3>
                        <p>
                            <% sb3 = new StringBuilder();
                               sb3.Append("<ul style=\"margin:0;padding:0;\">");
                               foreach (TaratripLinq.TblHotelSport gfp in l5) {
                                   sb3.Append(string.Format("<li style=\"list-style:none;\">- {0}</li>", gfp.Description));//, i == l2.Count - 1 ? "<br/><br/>" : ", "));
                                   i++;
                               }
                               sb3.Append("</ul>");%>
                            <%= sb3.ToString()%>  
                        </p>                          
                    <% } %>
                    <hr style="color:#ccc" />
                <%} %>
                <%if (l8.Count > 0) { %>
                <h1>Описание номеров</h1>
                <p>
                    <% StringBuilder stringBuilder = new StringBuilder();
                           foreach (TaratripLinq.TblHotelRoom item in l8) {
                               List<TaratripLinq.TblHotelRoomPeriodPrice> l9 = TaratripBiz.BizHotelRoom.GetHotelRoomPriceList(item.Id);
                               //if (l9.Count > 0) {
                                   //stringBuilder.Append(string.Format("<b>{0}:</b>", TaratripBiz.BizDictionary.GetHotelRoomTypeNameById(item.RoomTypeId)));
                                   stringBuilder.Append(string.Format("<div class=\"roomlist\"><table><tr><td class=\"nwr\"><b>{0}</b></td><td><div class=\"gro_assets\"><ul>"
                                                                                            , TaratripBiz.BizDictionary.GetHotelRoomTypeNameById(item.RoomTypeId)));

                                   if (item.IsConditioner.HasValue ? item.IsConditioner.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Кондиц."));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsKitchen.HasValue ? item.IsKitchen.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Кухня"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsLivingRoom.HasValue ? item.IsLivingRoom.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Гостиная"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsBalcony.HasValue ? item.IsBalcony.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Балкон"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsCupboard.HasValue ? item.IsCupboard.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Шкаф"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsSafebox.HasValue ? item.IsSafebox.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Сейф"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsFridge.HasValue ? item.IsFridge.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Холодильник"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsTV.HasValue ? item.IsTV.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "TV"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsHotWater.HasValue ? item.IsHotWater.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Гор.вода"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   if (item.IsSeaView.HasValue ? item.IsSeaView.Value : false) {
                                       stringBuilder.Append("        <li>");
                                       stringBuilder.Append(string.Format("{0}", "Вид на море"));
                                       stringBuilder.Append("        </li>");
                                   }
                                   stringBuilder.Append("</ul></div></td></tr>");
                                   stringBuilder.Append("<tr><td colspan=\"2\">");
                                   if (l9.Count > 0) {
                                       stringBuilder.Append("Цены на комнату:<br />");
                                       stringBuilder.Append(string.Format("<table style=\"width:600px;border:1px #ccc dashed;\"><tr>"));
                                       foreach (TaratripLinq.TblHotelRoomPeriodPrice pr in l9) {

                                           stringBuilder.Append(string.Format("<td>с {0} по {1}</td>", pr.DateStart.ToString("dd.MM"), pr.DateEnd.ToString("dd.MM")));

                                           stringBuilder.Append(string.Format("<td>{0} руб.</td>", pr.Price));
                                           stringBuilder.Append(string.Format("</tr>"));

                                       }
                                       //</table>
                                       stringBuilder.Append("</table>");
                                   }
                                   stringBuilder.Append("</td></tr>");
                                   stringBuilder.Append("</table>");


                                   stringBuilder.Append("</div>");    
                               //}
                               
                               }
                           
                        %>    
                            <%= stringBuilder.ToString() %>
                    <% } %>    
                    </p>    
                    
            </div>
        </div>
    </div>

    <div id="dialog-book">
        <%--<% using (Html.BeginForm("SendHotelBookMessage", "Home", FormMethod.Post, new { autocomplete = "off" })) { %>--%>
        <form method="post" id="msgForm" style="margin: 0 auto;" action="verifyHotelBooking.php">
        <h2>
            <label id="lblHotelname">
            </label>
        </h2>
        <div id="errorContact" class="error">&nbsp;</div>
        <table style="line-height:1.6em;">
            <tr>
                <td>
                    Ваше имя:
                </td>
                <td>
                    <div class="input-container">
                        <input name="nameContact" id="nameContact" type="text" style="width:250px;" />
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    Ваш контактный Email:
                </td>
                <td>
                    <div class="input-container">
                        <input name="emailContact" id="emailContact" type="text" style="width:250px;" />
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
                        <textarea name="contentContact" id="contentContact" rows="6" cols="70"></textarea>
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
                    <input type="submit" id="btnsubmit"  class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
                                                                                                    style="float: right;" value="Отправить запрос на бронирование" />
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
