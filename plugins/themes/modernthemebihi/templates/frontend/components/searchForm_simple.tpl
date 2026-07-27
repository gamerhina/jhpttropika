{**
 * templates/frontend/components/searchForm_simple.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Simple display of a search form with just text input and search button
 *
 * @uses $searchQuery string Previously input search query
 *}
{if !$currentJournal || $currentJournal->getData('publishingMode') != $smarty.const.PUBLISHING_MODE_NONE}
<form class="0" action="{url page="search" op="search"}" role="search" method="post" >
  <div class="pull-md-right">
    <div class="input-group">
      <input class="form-control" name="query" value="{$searchQuery|escape}" type="search" aria-label="{translate|escape key="common.searchQuery"}" placeholder="Enter keywords..">
      <button class="btn btn-light border" type="submit"><i class="fa fa-fw fa-search-plus"></i></button>
    </div>
  </div>
</form>
{/if}
