# Regression table helpers for the book
# This file provides HTML-formatted regression tables that match R's summary() output

using Printf

"""
    r_format_pvalue(p)

Format p-values like R does: "< 2e-16" for very small values, scientific notation otherwise
"""
function r_format_pvalue(p)
    if p < 2e-16
        return "&lt; 2e-16"
    elseif p < 0.001
        return @sprintf("%.3e", p)
    elseif p < 1
        return @sprintf("%.3f", p)
    else
        return @sprintf("%.3f", p)
    end
end

"""
    r_format_number(v)

Format numbers like R's summary(): 3 decimal places or scientific notation
"""
function r_format_number(v)
    if abs(v) >= 10000 || (abs(v) < 0.001 && v != 0)
        return @sprintf("%.3e", v)
    else
        return @sprintf("%.3f", v)
    end
end

"""
    significance_stars(p)

Return significance stars based on p-value
"""
function significance_stars(p)
    if p < 0.001
        return "***"
    elseif p < 0.01
        return "**"
    elseif p < 0.05
        return "*"
    elseif p < 0.1
        return "."
    else
        return ""
    end
end

"""
    show_regression_html(model; title="")

Display a regression model's summary as formatted HTML table, matching R's summary() format.
Works with any model that has a coeftable() method (GLM, Panelest, etc.)
"""
function show_regression_html(model; title="")
    ct = coeftable(model)
    
    if isempty(ct.rownms)
        return HTML("<p>(No coefficients to display)</p>")
    end
    
    # Only show first 4 columns (Coef, StdError, t/z, p-value) like R's summary
    num_cols = min(4, length(ct.cols))
    
    # Build HTML table as string
    html_str = ""
    
    if !isempty(title)
        html_str *= "<p><strong>$title</strong></p>"
    end
    
    # Column names - use R's naming
    r_colnames = ["Estimate", "Std. Error", "t value", "Pr(>|t|)"]
    # For GLM, the 3rd column might be "t" or "z"
    if length(ct.colnms) >= 3
        if ct.colnms[3] == "z"
            r_colnames[3] = "z value"
            r_colnames[4] = "Pr(>|z|)"
        end
    end
    
    # Create table with R-like styling
    html_str *= "<table style=\"border-collapse: collapse; font-family: monospace; font-size: 13px; margin: 0.5em 0;\">"
    
    # Header with bottom border
    html_str *= "<thead><tr>"
    html_str *= "<th style=\"text-align: left; padding: 4px 10px 4px 0; border-bottom: 1px solid black;\"></th>"
    for j in 1:num_cols
        html_str *= "<th style=\"text-align: right; padding: 4px 8px; border-bottom: 1px solid black;\">$(r_colnames[j])</th>"
    end
    html_str *= "</tr></thead>"
    
    # Body
    html_str *= "<tbody>"
    for i in eachindex(ct.rownms)
        html_str *= "<tr>"
        html_str *= "<td style=\"text-align: left; padding: 3px 10px 3px 0;\">$(ct.rownms[i])</td>"
        
        # Only process first 4 columns
        for j in 1:num_cols
            v = ct.cols[j][i]
            if v isa AbstractFloat
                # 4th column is p-value
                if j == 4
                    formatted_p = r_format_pvalue(v)
                    stars = significance_stars(v)
                    cell_content = stars == "" ? formatted_p : "$formatted_p $stars"
                    html_str *= "<td style=\"text-align: right; padding: 3px 8px; white-space: nowrap;\">$cell_content</td>"
                else
                    formatted = r_format_number(v)
                    html_str *= "<td style=\"text-align: right; padding: 3px 8px;\">$formatted</td>"
                end
            else
                html_str *= "<td style=\"text-align: right; padding: 3px 8px;\">$v</td>"
            end
        end
        html_str *= "</tr>"
    end
    
    # Significance codes footer
    html_str *= "<tr>"
    html_str *= "<td style=\"text-align: left; padding: 6px 0 0 0; border-top: 1px solid black;\" colspan=\"$(num_cols+1)\">"
    html_str *= "---<br/>"
    html_str *= "Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1"
    html_str *= "</td>"
    html_str *= "</tr>"
    
    html_str *= "</tbody></table>"
    
    # Use display() to immediately render the HTML in Jupyter/Quarto
    display("text/html", html_str)
    return nothing
end

# Convenience alias
const show_reg = show_regression_html
