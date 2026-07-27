{**
 * plugins/blocks/scholarCitationWidget/templates/sidebar.tpl
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Rendered widget template for sidebar
 *}
<link rel="stylesheet" href="{$scholarPluginPath}/css/widget.css?v=1.0.1">

<div class="pkp_block block_custom scholar-citation-widget" id="scholar-citation-sidebar-widget" style="--scholar-theme: {$scholarThemeColor|escape};">
    <h2 class="title">{$scholarSidebarTitle|escape}</h2>
    <div class="content">
        {if isset($scholarData.error)}
            <div class="scholar-error">
                {$scholarData.error|escape}
            </div>
        {else}
            <!-- Scholar Profile Summary -->
            <div class="scholar-profile">
                <span class="scholar-name">{$scholarData.profile.name|escape}</span>
            </div>

            <!-- Metrics Cards Grid -->
            <div class="scholar-stats">
                <div class="scholar-stat-card">
                    <span class="scholar-stat-val">{$scholarData.metrics.citations|escape}</span>
                    <span class="scholar-stat-lbl">{translate key="plugins.block.scholarCitationWidget.citations"}</span>
                </div>
                <div class="scholar-stat-card">
                    <span class="scholar-stat-val">{$scholarData.metrics.hindex|escape}</span>
                    <span class="scholar-stat-lbl">{translate key="plugins.block.scholarCitationWidget.hIndex"}</span>
                </div>
                <div class="scholar-stat-card">
                    <span class="scholar-stat-val">{$scholarData.metrics.i10index|escape}</span>
                    <span class="scholar-stat-lbl">{translate key="plugins.block.scholarCitationWidget.i10Index"}</span>
                </div>
            </div>

            <!-- Citation Graph -->
            {if $scholarShowGraph && isset($scholarData.chart) && count($scholarData.chart) > 0}
                <div class="scholar-chart-wrapper">
                    <canvas id="scholarSidebarChart" height="150"></canvas>
                </div>
                
                <!-- Pass data to JS safely using data attributes -->
                <div id="scholarChartData" 
                     data-years='{$scholarData.chart|@json_encode}' 
                     data-theme="{$scholarThemeColor|escape}" 
                     style="display:none;"></div>
            {/if}

            <!-- Bottom Action & Timestamp -->
            <div class="scholar-footer">
                {if $scholarShowButton}
                    <a href="{$scholarData.profile.url|escape}" class="scholar-btn" target="_blank" rel="noopener">
                        {translate key="plugins.block.scholarCitationWidget.viewProfile"}
                    </a>
                {/if}
                <span class="scholar-timestamp">
                    {translate key="plugins.block.scholarCitationWidget.updated"}: {$scholarData.updated|escape}
                </span>
            </div>
        {/if}
    </div>
</div>

{if !isset($scholarData.error) && $scholarShowGraph && isset($scholarData.chart) && count($scholarData.chart) > 0}
    <!-- Load Chart.js CDN and widget logic -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js" defer></script>
    <script src="{$scholarPluginPath}/js/widget.js?v=1.0.1" defer></script>
{/if}
