<script>

		var selectedItem;
		var selectedItemParent;
		var prevSelectedItemParent = null;


		function calculateDivHeight(){
	  		$("#accordion").height(window.innerHeight - {PositionTop});
	  		// $("#contentDiv").height(window.innerHeight - {PositionTop});
	  		$("#contentFrame").height(window.innerHeight - {PositionTop});
		};
	
		function calculateDivWidth(){
	  		// $("#contentDiv").width(window.innerWidth - {MenuWidth});
	  		$("#contentFrame").width(window.innerWidth - {MenuWidth});
		};
		
			$(window).resize(function () {
	  			calculateDivHeight();
	  			calculateDivWidth();
				}
			);


		calculateDivHeight();
		calculateDivWidth();

		function menuHeaderClick(item) {


			var link = $('#' + item.id);
			
			selectedItemParent = link;
			
			if (prevSelectedItemParent != null && (prevSelectedItemParent[0] == selectedItemParent[0])) return;
			var closest_ul = link.closest("ul");
			var parallel_active_links = closest_ul.find(".active");
			var closest_li = link.closest("li");
			var link_status = closest_li.hasClass("active");
			var count = 0;

			closest_ul.find("ul").slideUp(function(){
				if(++count == closest_ul.find("ul").length)

					parallel_active_links.removeClass("active");
			});

			if(!link_status)
			{
				closest_li.children("ul").slideDown();
				closest_li.addClass("active");
			}
			
			prevSelectedItemParent = selectedItemParent;
		};

		$(document).ready(function(){
			$("#accordion a").click(function(){
			   
			   return;
			   
				var link = $(this);
				var closest_ul = link.closest("ul");
				var parallel_active_links = closest_ul.find(".active");
				var closest_li = link.closest("li");
				var link_status = closest_li.hasClass("active");
				var count = 0;

				closest_ul.find("ul").slideUp(function(){
					if(++count == closest_ul.find("ul").length)

						parallel_active_links.removeClass("active");
				});

				if(!link_status)
				{
					closest_li.children("ul").slideDown();
					closest_li.addClass("active");
				}
			})
		});
 	
		function menuItemClick(item) {

			if (selectedItem) selectedItem.classList.remove("menu_selected");

                        $("[name='MenuIDTextBox']").SFCTextBox('option', 'text', item.id);
                        
                        if (item.getAttribute('data-link')) {
                            $("[name='MenuLinkTextBox']").SFCTextBox('option', 'text', item.getAttribute('data-link'));
			    document.getElementById("contentFrame").src = item.getAttribute('data-link');
                        }

                        if (item.getAttribute('data-key')) {
                            $("[name='MenuKeyTextBox']").SFCTextBox('option', 'text', item.getAttribute('data-key'));
                        }

			item.classList.add("menu_selected");
			selectedItem = item;
			
			
		};

		/* menuHeaderClick(document.getElementById("menuHeader1")); */
		 menuItemClick(document.getElementById("menuHeader1")); 
		
</script>
