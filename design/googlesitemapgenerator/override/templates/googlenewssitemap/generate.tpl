{set-block scope=root variable=cache_ttl}0{/set-block}

{if not( is_set( $node ) )}
	{def $node=fetch( 'content', 'node', hash( 'node_id', $start_node_id ) )}
{/if}

{def $depth=$node.depth|int()
	 $class_filter=ezini( 'Classes', 'ClassFilterArray', 'googlesitemapgenerator.ini' )
     $class_filter_type=ezini( 'Classes', 'ClassFilterType', 'googlesitemapgenerator.ini' )
     $main_node_only=ezini( 'NodeSettings', 'MainNodeOnly', 'googlesitemapgenerator.ini' )
     $show_untranslated_objects=ezini( 'RegionalSettings', 'ShowUntranslatedObjects', 'site.ini' )

     $change_freq=ezini( 'NodeChangeFreqSettings', 'NodeDepthChangefreq', 'googlesitemapgenerator.ini' )
     $standard_change_freq=ezini( 'StandardSettings', 'StandardChangefreq', 'googlesitemapgenerator.ini' )
     $node_change_freq_list=ezini( 'NodeChangeFreqSettings', 'NodeIndividualChangefreq', 'googlesitemapgenerator.ini' )
     $subtree_change_freq_list=ezini( 'SubtreeChangeFreqSettings', 'SubtreeChangefreq', 'googlesitemapgenerator.ini' )
     $folder_change_freq_modified=ezini( 'FolderChangeFreqSettings', 'FolderChangefreqModified', 'googlesitemapgenerator.ini' )
     $subtree_change_freq_modified=ezini( 'SubtreeChangeFreqSettings', 'SubtreeChangefreqModified', 'googlesitemapgenerator.ini' )

     $priority=ezini( 'NodePrioritySettings', 'NodeDepthPriority', 'googlesitemapgenerator.ini' )
     $standard_priority=ezini( 'StandardSettings', 'StandardPriority', 'googlesitemapgenerator.ini' )
     $node_priority_list=ezini( 'NodePrioritySettings', 'NodeIndividualPriority', 'googlesitemapgenerator.ini' )
     $subtree_priority_list=ezini( 'SubtreePrioritySettings', 'SubtreePriority', 'googlesitemapgenerator.ini' )
     $folder_priority_modified=ezini( 'FolderPrioritySettings', 'FolderPriorityModified', 'googlesitemapgenerator.ini' )
     $subtree_priority_modified=ezini( 'SubtreePrioritySettings', 'SubtreePriorityModified', 'googlesitemapgenerator.ini' )

     $node_visibility_list=ezini( 'NodeVisibilitySettings', 'NodeIndividualVisibility', 'googlesitemapgenerator.ini' )
     $subtree_visibility_list=ezini( 'SubtreeVisibilitySettings', 'SubtreeVisibility', 'googlesitemapgenerator.ini' )
     
     $news_publication_name=ezini('NewsSitemapSettings', 'PublicationName' , 'googlesitemapgenerator.ini' )
     $news_publication_lang=ezini('NewsSitemapSettings', 'PublicationLanguage' , 'googlesitemapgenerator.ini' )
     $news_genres=ezini('NewsSitemapSettings', 'NewsGenres' , 'googlesitemapgenerator.ini' )
	 $startDate=ezini('NewsSitemapSettings', 'StartDate' , 'googlesitemapgenerator.ini' )
	 $limit=ezini('NewsSitemapSettings', 'NewsLimit' , 'googlesitemapgenerator.ini' )

     $cur_timestamp=currentdate()
     $diff_last_modified=sub( $cur_timestamp, $node.object.modified )
     $request_uri='REQUEST_URI'|getenv
     $http_host='HTTP_HOST'|getenv
     $request_uri_list=$request_uri|explode( 'layout' )}

{if not( is_set( $sitemap_siteurl ) )}
    {def $sitemap_siteurl=concat( $http_host, $request_uri_list[0] )}
{/if}

{if and( is_set( $startDate ) , eq($startDate, '' )) }
{set $startDate = sub(currentdate() , mul(90,24,60,60))}
{else}
{set $startDate= sub(currentdate() , mul($startDate,24,60,60))}
{/if}

{* Get the value for <changefreq> *}
{if is_set( $subtree_change_freq_list[$node.node_id] )}
	{def $cur_subtree_change_freq=$subtree_change_freq_list[$node.node_id]
	     $output_change_freq=$subtree_change_freq_list[$node.node_id]}
{elseif and( ne( $cur_subtree_change_freq, null ), is_set( $cur_subtree_change_freq ) )}
	{def $output_change_freq=$cur_subtree_change_freq}
{elseif is_set( $subtree_change_freq_modified[$node.node_id] )}
    {def $output_change_freq=$standard_change_freq
         $change_freq_modified_set_info=$subtree_change_freq_modified[$node.node_id]|explode( ';' )
         $change_freq_modified_set=$change_freq_modified_set_info[0]
         $change_freq_modified_set_depth=$change_freq_modified_set_info[1]}

    {if eq( $change_freq_modified_set_depth, 0 )}
        {def $change_freq_tree_node_list=fetch( 'content', 'tree',
                                                 hash( 'parent_node_id', $node.node_id ) )}
    {else}
        {def $change_freq_tree_node_list=fetch( 'content', 'tree',
                                                 hash( 'parent_node_id', $node.node_id,
                                 	                   'depth', $change_freq_modified_set_depth ) )}
    {/if}

    {def $change_freq_min_last_modified=0}

    {foreach $change_freq_tree_node_list as $change_freq_tree_node}
        {if eq( $change_freq_min_last_modified, 0 )}
    	    {set $change_freq_min_last_modified=$change_freq_tree_node.object.modified}
    	{else}
    	    {if lt( $change_freq_tree_node.object.modified, $change_freq_min_last_modified )}
    	        {set $change_freq_min_last_modified=$change_freq_tree_node.object.modified}
    	    {/if}
    	{/if}
    {/foreach}

    {def $change_freq_min_last_modified_intervall=sub( $cur_timestamp, $change_freq_min_last_modified )
         $subtree_change_freq_modified_set_list=ezini( 'SubtreeChangeFreqSettings', $change_freq_modified_set, 'googlesitemapgenerator.ini' )}

    {foreach $subtree_change_freq_modified_set_list as $subtree_change_freq_modified_set}
        {def $subtree_change_freq_modified_set_info=$subtree_change_freq_modified_set|explode( ';' )
             $change_freq_time_intervall=$subtree_change_freq_modified_set_info[0]
             $change_freq_modified=$subtree_change_freq_modified_set_info[1]}
             {if le( $change_freq_min_last_modified_intervall, $change_freq_time_intervall )}
             	{def $output_change_freq=$change_freq_modified}
             	{break}
             {/if}
    {/foreach}

    {def $cur_subtree_change_freq_modified=$output_change_freq}
{elseif and( ne( $cur_subtree_change_freq_modified, null ), is_set( $cur_subtree_change_freq_modified ) )}
	{def $output_change_freq=$cur_subtree_change_freq_modified}
{/if}

{if not( is_set( $output_change_freq ) )}
	{if is_set( $change_freq[$depth] )}
		{def $output_change_freq=$change_freq[$depth]}
	{else}
		{def $output_change_freq=$standard_change_freq}
	{/if}
{/if}

{if is_set( $folder_change_freq_modified[$node.parent_node_id] )}
	{def $output_change_freq=$standard_change_freq
	     $change_freq_folder_min_last_modified_intervall=sub( $cur_timestamp, $node.object.modified )
	     $folder_change_freq_modified_set_list=ezini( 'FolderChangeFreqSettings', $folder_change_freq_modified[$node.parent_node_id], 'googlesitemapgenerator.ini' )}

	{foreach $folder_change_freq_modified_set_list as $folder_change_freq_modified_set}
	    {def $folder_change_freq_modified_set_info=$folder_change_freq_modified_set|explode( ';' )
	         $change_freq_folder_time_intervall=$folder_change_freq_modified_set_info[0]
	         $folder_change_freq_modified=$folder_change_freq_modified_set_info[1]}
	         {if le( $change_freq_folder_min_last_modified_intervall, $change_freq_folder_time_intervall )}
	         	{def $output_change_freq=$folder_change_freq_modified}
	         	{break}
	         {/if}
	{/foreach}
{/if}

{if is_set( $node_change_freq_list[$node.node_id] )}
	{def $output_change_freq=$node_change_freq_list[$node.node_id]}
{/if}


{* Get value for <priority> *}
{if is_set( $subtree_priority_list[$node.node_id] )}
	{def $cur_subtree_priority=$subtree_priority_list[$node.node_id]
	     $output_priority=$subtree_priority_list[$node.node_id]}
{elseif and( ne( $cur_subtree_priority, null ), is_set( $cur_subtree_priority ) )}
	{def $output_priority=$cur_subtree_priority}
{elseif is_set( $subtree_priority_modified[$node.node_id] )}
	{def $output_priority=$standard_priority
	     $modified_set_info=$subtree_priority_modified[$node.node_id]|explode( ';' )
         $modified_set=$modified_set_info[0]
         $modified_set_depth=$modified_set_info[1]}

    {if eq( $modified_set_depth, 0 )}
    	{def $tree_node_list=fetch( 'content', 'tree',
                                     hash( 'parent_node_id', $node.node_id ) )}
    {else}
    	{def $tree_node_list=fetch( 'content', 'tree',
                                     hash( 'parent_node_id', $node.node_id,
                                 	       'depth', $modified_set_depth ) )}
    {/if}

    {def $min_last_modified=0}

    {foreach $tree_node_list as $tree_node}
       	{if eq( $min_last_modified, 0 )}
    	    {set $min_last_modified=$tree_node.object.modified}
    	{else}
    	    {if lt( $tree_node.object.modified, $min_last_modified )}
    	        {set $min_last_modified=$tree_node.object.modified}
    	    {/if}
    	{/if}
    {/foreach}

    {def $min_last_modified_intervall=sub( $cur_timestamp, $min_last_modified )
         $subtree_priority_modified_set_list=ezini( 'SubtreePrioritySettings', $modified_set, 'googlesitemapgenerator.ini' )}

    {foreach $subtree_priority_modified_set_list as $subtree_priority_modified_set}
        {def $subtree_priority_modified_set_info=$subtree_priority_modified_set|explode( ';' )
             $time_intervall=$subtree_priority_modified_set_info[0]
             $priority_modified=$subtree_priority_modified_set_info[1]}
             {if le( $min_last_modified_intervall, $time_intervall )}
             	{def $output_priority=$priority_modified}
             	{break}
             {/if}
    {/foreach}

    {def $cur_subtree_priority_modified=$output_priority}
{elseif and( ne( $cur_subtree_priority_modified, null ), is_set( $cur_subtree_priority_modified ) )}
	{def $output_priority=$cur_subtree_priority_modified}
{/if}

{if not( is_set( $output_priority ) )}
	{if is_set( $priority[$depth] )}
		{def $output_priority=$priority[$depth]}
	{else}
		{def $output_priority=$standard_priority}
	{/if}
{/if}

{if is_set( $folder_priority_modified[$node.parent_node_id] )}
	{def $output_priority=$standard_priority
	     $folder_min_last_modified_intervall=sub( $cur_timestamp, $node.object.modified )
	     $folder_priority_modified_set_list=ezini( 'FolderPrioritySettings', $folder_priority_modified[$node.parent_node_id], 'googlesitemapgenerator.ini' )}

	{foreach $folder_priority_modified_set_list as $folder_priority_modified_set}
	    {def $folder_priority_modified_set_info=$folder_priority_modified_set|explode( ';' )
	         $folder_time_intervall=$folder_priority_modified_set_info[0]
	         $folder_priority_modified=$folder_priority_modified_set_info[1]}
	         {if le( $folder_min_last_modified_intervall, $folder_time_intervall )}
	         	{def $output_priority=$folder_priority_modified}
	         	{break}
	         {/if}
	{/foreach}
{/if}

{if is_set( $node_priority_list[$node.node_id] )}
	{def $output_priority=$node_priority_list[$node.node_id]}
{/if}


{* Get visibility fpr current Node *}
{if is_set( $subtree_visibility_list[$node.node_id] )}
	{def $cur_subtree_visibility=$subtree_visibility_list[$node.node_id]
	     $output_visibility=$subtree_visibility_list[$node.node_id]}
{elseif and( ne( $cur_subtree_visibility, null ), is_set( $cur_subtree_visibility ) )}
	{def $output_visibility=$cur_subtree_visibility}
{else}
	{def $output_visibility='show'}
{/if}

{if is_set( $node_visibility_list[$node.node_id] )}
	{def $output_visibility=$node_visibility_list[$node.node_id]}
{/if}

{* Generate XML-output for one node *}
{if eq( $output_visibility, 'show' )}
    <url>
        <loc>{concat( 'http://', $sitemap_siteurl, $node.url_alias )}</loc>
        <n:news>
      <n:publication>
        <n:name>{$news_publication_name}</n:name>
        <n:language>{$news_publication_lang}</n:language>
      </n:publication>
      <n:genres>{$news_genres}</n:genres>
      <n:publication_date>{$node.object.modified|datetime( 'custom', '%Y-%m-%d' )}</n:publication_date>
      <n:title>{$node.data_map.name.content|wash}</n:title>
      <n:keywords>{$node.data_map.keywords.content|wash}</n:keywords>
    </n:news>
   </url>
{/if}


{* Getting Node-list for going through it recursively *}
     {if eq( $show_untranslated_objects, 'disabled' )}
         {def $only_translated='true()'}
     {else}
         {def $only_translated='false()'}
     {/if}

{def $sitemap_node_list=fetch( 'content', 'list',
                                hash( 'parent_node_id',     $node.node_id,
                                      'sort_by',            $node.sort_array,
                                      'class_filter_type',  $class_filter_type,
                                      'class_filter_array', $class_filter,
                                      'main_node_only',     $main_node_only,
                                      'only_translated',    $only_translated,
									  'attribute_filter', array( and,
                       					array( 'modified_subnode', '>=', $startDate ),
                       					array( 'modified_subnode', '<=', currentdate() ) ),
                       					'limit', $limit,
                                       ) ) }


{foreach $sitemap_node_list as $sitemap_node_item}
	{if not( is_set( $cur_subtree_change_freq ) )}
		{def $cur_subtree_change_freq=null}
	{/if}
	{if not( is_set( $cur_subtree_change_freq_modified ) )}
		{def $cur_subtree_change_freq_modified=null}
	{/if}
	{if not( is_set( $cur_subtree_priority ) )}
		{def $cur_subtree_priority=null}
	{/if}
	{if not( is_set( $cur_subtree_priority_modified ) )}
		{def $cur_subtree_priority_modified=null}
	{/if}
	{if not( is_set( $cur_subtree_visibility ) )}
		{def $cur_subtree_visibility=null}
	{/if}
    {node_view_gui view=googlenewssitemap content_node=$sitemap_node_item sitemap_siteurl=$sitemap_siteurl cur_subtree_change_freq=$cur_subtree_change_freq cur_subtree_change_freq_modified=$cur_subtree_change_freq_modified cur_subtree_priority=$cur_subtree_priority cur_subtree_priority_modified=$cur_subtree_priority_modified cur_subtree_visibility=$cur_subtree_visibility}
{/foreach}
