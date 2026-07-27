(function() {
    function initChart() {
        if (typeof Chart === 'undefined') {
            setTimeout(initChart, 50);
            return;
        }
        var dataEl = document.getElementById('scholarChartData');
        if (!dataEl) return;
        
        var chartDataRaw = dataEl.getAttribute('data-years');
        if (!chartDataRaw) return;
        
        var chartData;
        try {
            chartData = JSON.parse(chartDataRaw);
        } catch (e) {
            console.error('Failed to parse Scholar chart data', e);
            return;
        }
        
        var themeColor = dataEl.getAttribute('data-theme') || '#014401';
        
        var years = [];
        var citations = [];
        
        chartData.forEach(function(item) {
            years.push(item.year);
            citations.push(item.citations);
        });
        
        var canvas = document.getElementById('scholarSidebarChart');
        if (!canvas) return;
        
        var ctx = canvas.getContext('2d');
        
        // Solid theme color for bars with hover effect
        var barColor = themeColor;
        var barHoverColor = themeColor;
        if (themeColor.startsWith('#') && themeColor.length === 7) {
            barColor = themeColor + 'CC'; // 80% opacity
        }

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: years,
                datasets: [{
                    data: citations,
                    backgroundColor: barColor,
                    hoverBackgroundColor: barHoverColor,
                    borderRadius: 3,
                    borderSkipped: false,
                    barPercentage: 0.7,
                    categoryPercentage: 0.8
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.85)',
                        titleFont: { size: 11, weight: 'bold' },
                        bodyFont: { size: 11 },
                        padding: 8,
                        displayColors: false,
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y + ' Citations';
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { font: { size: 10, weight: '500' }, color: '#495057' }
                    },
                    y: {
                        beginAtZero: true,
                        grid: { color: '#f1f3f5' },
                        ticks: { font: { size: 9 }, color: '#868e96', precision: 0 }
                    }
                }
            }
        });
    }
    
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initChart);
    } else {
        initChart();
    }
})();
