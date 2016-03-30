<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:util="http://dtd.nlm.nih.gov/xsl/util" 
    xmlns:string="http://localhost"
    xmlns:func="http://exslt.org/functions"
    extension-element-prefixes="func"
    exclude-result-prefixes="util xsl xlink func string">
    <xsl:output encoding="utf-8" method="html" indent="yes"/>
    
    <!-- https://gist.github.com/zimmen/1415416 -->
    <func:function name="string:replace">
        <xsl:param name="in" />
        <xsl:param name="needle" />
        <xsl:param name="replace" select="''" />
        <func:result>
            <xsl:choose>
                <xsl:when test="contains($in, $needle)">
                    <xsl:value-of select="substring-before($in, $needle)" />
                    <xsl:value-of select="$replace" />
                    <xsl:value-of select="string:replace(substring-after($in, $needle),$needle,$replace)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$in" />
                </xsl:otherwise>
            </xsl:choose>
        </func:result>
    </func:function>
    <xsl:template match="/">
        <html>
            <head>
                <title><xsl:value-of select="doc/doctitle"/></title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <style type="text/css">
                    *, body{
                    font-size: 12.0 pt;
                    font-family: "Arial","sans-serif";
                    }
                    .doc, .tr, .td, .th, .ref, .contract, .edition{
                    color: #FD9BCB;
                    }
                    .toctitle, .graphic, .list, .source, .kwd, .onbehalf, .ack, .issn, .def{
                    color: #389867;
                    }
                    .doctitle, .country, .xmlbody, .sec, .subsec, .sectitle, .caption, .equation, .li, .authors, .moreinfo, .pages, .pubid, .url{
                    color: #7F0F7E;
                    }
                    .author, .fname, .surname, .arttitle{
                    color: #389867;
                    }
                    .xref, .subtitle, .pauthor, .et-al, .pubname, .part, .cited, .thesgrp{
                    color: #FC28FC;
                    }
                    .normaff, .city, .quote, .isbn, .extent, .series, .ctreg, .suppl, .series, .deflist{
                    color: #FC0D1B;
                    }
                    .label, .email, .p, .xmlabstr, .kwdgrp, .boxedtxt, .patentno{
                    color: #7E0308;
                    }
                    .orgname, .publoc, .tabwrap, .refs, .fngrp, .issueno, .reportid, .volid{
                    color: #2DFFFE;
                    }
                    .corresp{
                    color: #7F0308;
                    }
                    .figgrp, .cauthor, .date, .cltrial, .revised, .received, .accepted, .supplmat, .defitem{
                    color: #0F7F12;
                    }
                    .doi, .chptitle, .hist, .table, .thead, .tbody, .confgrp{
                    color: #11807F;
                    }
                    .product, .corpauth, .text-ref{
                    color: #FC6621;
                    }
                    .related, .term{
                    color: #0B24FB;
                    }
                    table {
                    border-collapse: collapse;
                    }
                    .cell-border {
                    border: 1px solid #EEE;
                    }
                </style>
            </head>
            <body>
                <xsl:apply-templates select="doc" mode="format"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="*" mode="format">
        <xsl:apply-templates select="." mode="markup"/>
    </xsl:template>
    <xsl:template match="doc|author|corpauth|onbehalf|normaff|corresp|product|cltrial|hist|revised|received|accepted|related|xmlabstr|kwdgrp|xmlbody|ack|refs|ref|text-ref|subsec|figgrp|equation|list|li|tabwrap|*[name(..) != 'li']/p|*[name(..) != 'equation' and name(..) != 'p']/graphic|boxedtxt|deflist|defitem" mode="format">
        <xsl:choose>
            <xsl:when test="doc|author|corpauth|onbehalf|normaff|corresp|product|cltrial|hist|revised|received|accepted|related|xmlabstr|kwdgrp|xmlbody|ack|refs|ref|subsec|figgrp|equation|list|li|tabwrap|*[name(..) != 'li']/p|*[name(..) != 'equation' and name(..) != 'p']/graphic|boxedtxt|p|table|deflist|defitem">
                <p><xsl:apply-templates select="." mode="open-tag"/></p>
                <xsl:apply-templates mode="format"/>
                <p><xsl:apply-templates select="." mode="close-tag"/></p>
            </xsl:when>
            <xsl:otherwise>
                <p><xsl:apply-templates select="." mode="markup"/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="list|quote" mode="format">
        <blockquote>
            <xsl:apply-templates select="." mode="markup"/>
        </blockquote>
    </xsl:template>
    <xsl:template match="doi|toctitle" mode="format">
        <p style="text-align:right">
            <xsl:apply-templates select="." mode="markup"/>
        </p>
    </xsl:template>
    <xsl:template match="doctitle"  mode="format">
        <p style="text-align:center">
            <xsl:apply-templates select="." mode="markup"/>
        </p>
    </xsl:template>
    
    <xsl:template match="table" mode="format">
        <p><xsl:apply-templates select="." mode="open-tag"/></p>
            <xsl:element name="{name()}">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates mode="format"/>
            </xsl:element>
        <p><xsl:apply-templates select="." mode="close-tag"/></p>
    </xsl:template>
    <xsl:template match="thead|tbody" mode="format">
        <tr><td><xsl:apply-templates select="." mode="open-tag"/></td></tr>
        <xsl:apply-templates mode="format"/>
        <tr><td><xsl:apply-templates select="." mode="close-tag"/></td></tr>
    </xsl:template>
    <xsl:template match="tr" mode="format">
        <tr>
            <td><xsl:apply-templates select="." mode="open-tag"/></td>
            <xsl:apply-templates mode="format"/>
            <td><xsl:apply-templates select="." mode="close-tag"/></td>
        </tr>
    </xsl:template>
    <xsl:template match="td|th" mode="format">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="class">
                cell-border
            </xsl:attribute>
            <xsl:apply-templates select="." mode="open-tag"/>
            <xsl:apply-templates mode="format"/>
            <xsl:apply-templates select="." mode="close-tag"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="text-ref" mode="format">
        <xsl:apply-templates select="." mode="markup"/>
        <br/>
    </xsl:template>
    <xsl:template match="fngrp" mode="format">
        <p>
            <xsl:apply-templates select="." mode="markup">
                <xsl:sort select="@label" data-type="number"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>
    
    
    <xsl:template match="*" mode="markup">
        <xsl:apply-templates select="." mode="open-tag"/>
        <xsl:apply-templates mode="format"/>
        <xsl:apply-templates select="." mode="close-tag"/>
    </xsl:template>
    <xsl:template match="*" mode="open-tag">
        <span class="{name()}">
            <xsl:text>[</xsl:text>
            <xsl:value-of select ="name()"/>
            <xsl:apply-templates select="@*"/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="*" mode="close-tag">
        <span class="{name()}">
            <xsl:text>[/</xsl:text>
            <xsl:value-of select ="name()"/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:text> </xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>="</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="format">
        <xsl:choose>
            <xsl:when test="normalize-space(.)=''"/>
            <xsl:otherwise>
                <xsl:value-of select="string:replace(string:replace(., '[', '&amp;#91;'), ']', '&amp;#93;')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="bold|italic" mode="markup">
        <xsl:variable name="el">
            <xsl:choose>
                <xsl:when test="name()='bold'">strong</xsl:when>
                <xsl:when test="name()='italic'">em</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$el}"><xsl:apply-templates mode="format"/></xsl:element>
    </xsl:template>
    <xsl:template match="sup|sub|img" mode="markup">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="format"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>