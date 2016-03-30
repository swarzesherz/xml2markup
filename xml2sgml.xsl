<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:util="http://dtd.nlm.nih.gov/xsl/util" 
    xmlns:mml="http://www.w3.org/1998/Math/MathML" 
    exclude-result-prefixes="util xsl xlink mml">
    <xsl:output encoding="utf-8" method="html" indent="yes"/>
    
    <!-- text -->
    <xsl:template match="*/text()">
        <xsl:value-of select="." disable-output-escaping="no"/>
    </xsl:template>
    
    <!-- nodes -->
    <xsl:template match="*">
        <xsl:apply-templates select="@*| * | text()"/>
    </xsl:template>
    <xsl:template match="@*">
        <xsl:attribute name="{name()}"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
        <!--xsl:value-of select="name()"/>="<xsl:value-of select="normalize-space(.)"/>" -->
    </xsl:template>
    <!-- mode=text -->
    <xsl:template match="*" mode="text-only">
        <xsl:apply-templates select="*|text()" mode="text-only"/>
    </xsl:template>
    
    
    <xsl:template match="attrib | series | app | anonym | isbn | glossary | term | def | response | p | sec | label | subtitle | edition |  issn | corresp | ack | tbody | td | tr | source | kwd | term">
        <xsl:param name="id"/>
        
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | * | text()">
                <xsl:with-param name="id" select="$id"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    <xsl:template match="e-mail|email">
        <email>
            <xsl:value-of select="normalize-space(.)"/>
        </email>
    </xsl:template>
    
    <xsl:template match="@specific-use">
        <xsl:attribute name="sps">
            <xsl:choose>
                <xsl:when test="contains(.,'sps-')"><xsl:value-of select="substring-after(.,'sps-')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@article-type" mode="type">
        <xsl:attribute name="doctopic">
            <xsl:choose>
                <xsl:when test=".='research-article'">oa</xsl:when>
                <xsl:when test=".='abstract'">ab</xsl:when>
                <xsl:when test=".='announcement'">an</xsl:when>
                <xsl:when test=".='article-commentary'">co</xsl:when>
                <xsl:when test=".='case-report'">cr</xsl:when>
                <xsl:when test=".='clinical-trial'">ct</xsl:when>
                <xsl:when test=".='editorial'">ed</xsl:when>
                <xsl:when test=".='letter'">le</xsl:when>
                <xsl:when test=".='review-article'">ra</xsl:when>
                <xsl:when test=".='rapid-communication'">sc</xsl:when>
                <xsl:when test=".='addendum'">??</xsl:when>
                <xsl:when test=".='book-review'">rc</xsl:when>
                <xsl:when test=".='books-received'">??</xsl:when>
                <xsl:when test=".='brief-report'">rn</xsl:when>
                <xsl:when test=".='calendar'">??</xsl:when>
                <xsl:when test=".='collection'">??</xsl:when>
                <xsl:when test=".='correction'">er</xsl:when>
                <xsl:when test=".='discussion'">??</xsl:when>
                <xsl:when test=".='dissertation'">??</xsl:when>
                <xsl:when test=".='in-brief'">pr</xsl:when>
                <xsl:when test=".='introduction'">??</xsl:when>
                <xsl:when test=".='meeting-report'">??</xsl:when>
                <xsl:when test=".='news'">pr</xsl:when>
                <xsl:when test=".='obituary'">??</xsl:when>
                <xsl:when test=".='oration'">??</xsl:when>
                <xsl:when test=".='partial-retraction'">re</xsl:when>
                <xsl:when test=".='product-review'">rc</xsl:when>
                <xsl:when test=".='reply'">??</xsl:when>
                <xsl:when test=".='reprint'">??</xsl:when>
                <xsl:when test=".='retraction'">re</xsl:when>
                <xsl:when test=".='translation'">??</xsl:when>
                <xsl:when test=".='other'">ax</xsl:when>
                <xsl:when test=".='editorial-material'">in</xsl:when><!-- interview -->
                <xsl:when test=".='research-article'">mt</xsl:when><!-- methodology -->
                <xsl:when test=".='editorial-material'">pv</xsl:when><!-- ponto de vista -->
                <xsl:when test=".='technical-report'">tr</xsl:when><!-- technical report -->
                <xsl:when test=".='other'">zz</xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@xml:lang">
        <xsl:if test="not(.='unknown')">
            <xsl:attribute name="language"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
        </xsl:if>
    </xsl:template>    
    
    <xsl:template match="@contrib-type">
        <xsl:attribute name="role">
            <xsl:choose>
                <xsl:when test=".='author'">nd</xsl:when>
                <xsl:when test=".='editor'">ed</xsl:when>
                <xsl:when test=".='translator'">tr</xsl:when>
                <xsl:when test=".='rev'">rev</xsl:when>
                <xsl:when test=".='coordinator'">coord</xsl:when>
                <xsl:when test=".='organizer'">org</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="xref">
        <xsl:variable name="text"><xsl:apply-templates select="*|text()" mode="text-only"/></xsl:variable>
        <xsl:element name="{name()}">
            <xsl:choose>
                <xsl:when test="not(@ref-type) and starts-with(@rid, 'fn')">
                    <xsl:attribute name="ref-type">fn</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="sup/text() = normalize-space($text)">
                    <sup><xsl:value-of select="normalize-space($text)"/></sup>
                </xsl:when>
                <xsl:otherwise><xsl:apply-templates select="*|text()"/></xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="xref[@ref-type='aff']">
        <xref>
            <xsl:copy-of select="@*"/>
            <sup><xsl:value-of select="."/></sup>
        </xref>
    </xsl:template>
    <xsl:template match="xref[@ref-type='bibr']/@rid">
        <xsl:attribute name="rid">r<xsl:value-of select="string(number(substring(.,2)))"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="xref[@ref-type='FN']/@ref-type">
        <xsl:attribute name="ref-type">fn</xsl:attribute>
    </xsl:template>

    <xsl:template name="dateiso">
        <xsl:param name="day" select="''"/>
        <xsl:param name="month" select="''"/>
        <xsl:param name="year" select="''"/>
        <xsl:variable name="dateiso">
            <xsl:value-of select="$year"/><xsl:if test="$year=''">0000</xsl:if>
            <xsl:value-of select="$month"/><xsl:if test="$month=''">00</xsl:if>
            <xsl:value-of select="$day"/><xsl:if test="$day=''">00</xsl:if>
        </xsl:variable>
        <date>
            <xsl:attribute name="dateiso"><xsl:value-of select="$dateiso"/></xsl:attribute>
            <xsl:attribute name="specyear"><xsl:value-of select="$year"/></xsl:attribute>
            <xsl:value-of select="$dateiso"/>
        </date>
    </xsl:template>
    
    <xsl:template match="article">
        <doc>
            <xsl:apply-templates select="@specific-use"/>
            <xsl:apply-templates select="front/journal-meta" mode="attribute"/>
            <xsl:apply-templates select="front/article-meta" mode="attribute"/>
            <xsl:apply-templates select="@article-type" mode="type"/>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates select="." mode="front">
                <xsl:with-param name="language" select="@xml:lang"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="." mode="body"/>
            <xsl:apply-templates select="." mode="back"/>
        </doc>
    </xsl:template>
    
    <xsl:template match="journal-meta" mode="attribute">
        <xsl:if test="journal-id[@journal-id-type='publisher-id']">
            <xsl:attribute name="acron"><xsl:value-of select="journal-id[@journal-id-type='publisher-id']"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="jtitle"><xsl:value-of select="journal-title-group/journal-title"/></xsl:attribute>
        <xsl:if test="journal-title-group/abbrev-journal-title[@abbrev-type='publisher']">
            <xsl:attribute name="stitle"><xsl:value-of select="journal-title-group/abbrev-journal-title[@abbrev-type='publisher']"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="journal-id[@journal-id-type='nlm-ta']">
            <xsl:attribute name="nlmtitle"><xsl:value-of select="journal-id[@journal-id-type='nlm-ta']"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="issn">
            <xsl:choose>
                <xsl:when test="issn[@pub-type='ppub']"><xsl:value-of select="issn[@pub-type='ppub']"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="issn[pub-type='epub']"/></xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:if test="issn[@pub-type='ppub']">
            <xsl:attribute name="pissn"><xsl:value-of select="issn[@pub-type='ppub']"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="issn[pub-type='epub']">
            <xsl:attribute name="eissn"><xsl:value-of select="issn[pub-type='epub']"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="pubname"><xsl:value-of select="publisher/publisher-name"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="article-meta" mode="attribute">
        <xsl:attribute name="license"><xsl:value-of select="permissions/license/@xlink:href"/></xsl:attribute>
        <xsl:if test="number(volume) &gt; 0">
            <xsl:attribute name="volid"><xsl:value-of select="volume"/></xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="issue"/>
        <xsl:apply-templates select="pub-date"/>
        <xsl:attribute name="order">
            <xsl:choose>
                <xsl:when test="article-id[@pub-id-type='pii']"><xsl:value-of select="format-number(number(//article-meta/article-id[@pub-id-type='pii']), '00')"/></xsl:when>
                <xsl:when test="article-id[@pub-id-type='other']"><xsl:value-of select="format-number(number(//article-meta/article-id[@pub-id-type='other']), '00')"/></xsl:when>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="fpage"><xsl:value-of select="fpage"/></xsl:attribute>
        <xsl:attribute name="lpage"><xsl:value-of select="lpage"/></xsl:attribute>
        <xsl:attribute name="pagcount"><xsl:value-of select="counts/page-count/@count"/></xsl:attribute>
        <xsl:if test="article-id[@specific-use='previous-pid']">
            <xsl:attribute name="ahppid"><xsl:value-of select="article-id[@specific-use='previous-pid']"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="elocation-id">
            <xsl:attribute name="elocatid"><xsl:value-of select="elocation-id"/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    <!-- TODO @isidpart -->
    <xsl:template match="article-meta/issue">
        <xsl:choose>
            <xsl:when test="contains(.,' Suppl ')">
                <xsl:attribute name="issueno"><xsl:value-of select="substring-before(.,' Suppl ')"/></xsl:attribute>
                <xsl:variable name="supplements"><xsl:value-of select="substring-after(.,' Suppl ')"/></xsl:variable>
                <xsl:choose>
                    <xsl:when test="contains($supplements,' Suppl ')">
                        <xsl:attribute name="supplno"><xsl:value-of select="substring-before($supplements,' Suppl ')"/></xsl:attribute>
                        <xsl:attribute name="supplvol"><xsl:value-of select="substring-after($supplements,' Suppl ')"/></xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="supplno"><xsl:value-of select="$supplements"/></xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="starts-with(., 'Suppl ')">
                <xsl:attribute name="supplvol"><xsl:value-of select="substring-after(.,'Suppl ')"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="issueno"><xsl:value-of select="."/></xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="article-meta/pub-date">
        <xsl:attribute name="dateiso">
            <xsl:value-of select="year"/><xsl:if test="not(year)">0000</xsl:if>
            <xsl:value-of select="month"/><xsl:if test="not(month)">00</xsl:if>
            <xsl:value-of select="day"/><xsl:if test="not(day)">00</xsl:if>
        </xsl:attribute>
        <xsl:if test="season">
            <xsl:attribute name="season"><xsl:value-of select="translate(season, '-', '/') "/></xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <!-- front -->
    <xsl:template match="article" mode="front">
        <xsl:param name="language"/>
        <xsl:apply-templates select="front/article-meta" mode="article-meta">
            <xsl:with-param name="language" select="$language"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="front/article-meta" mode="article-meta">
        <xsl:param name="language"/>
        <xsl:apply-templates select="article-id[@pub-id-type='doi']"/>
        <xsl:apply-templates select="article-categories/subj-group[@subj-group-type='heading']"/>
        <xsl:apply-templates select="title-group|title-group/trans-title-group"/>
        <xsl:apply-templates select="contrib-group"/>
        <xsl:apply-templates select="aff" mode="front-aff"/>
        <xsl:apply-templates select="author-notes/corresp"/>
        <xsl:apply-templates select="product" mode="product-in-article-meta"/>
        <xsl:apply-templates select="uri[@content-type='clinical-trial']"/>
        <xsl:apply-templates select="history"/>
        <xsl:apply-templates select="related-article" mode="front-related"/>
        <xsl:apply-templates select="abstract|trans-abstract">
            <xsl:with-param name="language"><xsl:value-of select="$language"/></xsl:with-param>
        </xsl:apply-templates>
        <xsl:apply-templates select="kwd-group">
            <xsl:with-param name="language"><xsl:value-of select="$language"/></xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="article-id[@pub-id-type='doi']">
        <doi><xsl:value-of select="."/></doi>
    </xsl:template>
    <xsl:template match="subj-group[@subj-group-type='heading']">
        <toctitle>
            <italic><xsl:value-of select="subject"/></italic>
        </toctitle>
    </xsl:template>
    <xsl:template match="title-group|trans-title-group" >
        <doctitle>
            <xsl:apply-templates select="@xml:lang"/>
            <bold>
                <italic>
                    <xsl:value-of select="article-title|trans-title"/>
                </italic>
            </bold>
            <xsl:apply-templates select="subtitle|trans-subtitle"/>
        </doctitle>
    </xsl:template>
    <xsl:template match="title-group/subtitle|trans-title-group/trans-subtitle">
        <subtitle><bold><italic><xsl:value-of select="."/></italic></bold></subtitle>
    </xsl:template>
    
    
    <xsl:template match="front/article-meta/contrib-group">
        <xsl:apply-templates select="contrib[@contrib-type='author']"/>
        <xsl:apply-templates select="on-behalf-of"/>
        <xsl:apply-templates select="aff" mode="front-aff"/>
    </xsl:template>
    <xsl:template match="contrib[@contrib-type='author']/@*[.='yes']">
        <xsl:attribute name="{name()}">y</xsl:attribute>
    </xsl:template>
    <xsl:template match="contrib[@contrib-type='author']">
        <xsl:choose>
            <xsl:when test="name">
                <author>
                    <xsl:apply-templates select="@*"/>
                    <xsl:attribute name="rid">
                        <xsl:text>a</xsl:text>
                        <xsl:value-of select="format-number(position(), '00')"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="name/given-names"/>
                    <xsl:apply-templates select="name/surname"/>
                    <xsl:apply-templates select="xref"/>
                </author>
            </xsl:when>
            <xsl:when test="collab">
                <xsl:apply-templates select="collab"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="on-behalf-of">
        <onbehalf>
            <xsl:apply-templates select="*|text()"/>
        </onbehalf>
    </xsl:template>
    <xsl:template match="given-names">
        <fname>
            <xsl:apply-templates select="*|text()" mode="text-only"/>
        </fname>
    </xsl:template>
    <xsl:template match="surname">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="*|text()" mode="text-only"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="article-meta/aff|article-meta/contrib-group/aff" mode="front-aff">
        <xsl:variable name="original"><xsl:value-of select="institution[@content-type='original']"/></xsl:variable>
        <normaff>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="country" mode="front-aff"/>
            <xsl:apply-templates select="institution[@content-type='normalized']"/>
            <xsl:apply-templates select="label" mode="front-aff"/>
            <xsl:value-of select="institution[@content-type='original']"/>
        </normaff>
    </xsl:template>
    <xsl:template match="label" mode="front-aff">
        <label><sup><xsl:value-of select="."/></sup></label>
    </xsl:template>
    <xsl:template match="country" mode="front-aff">
        <xsl:attribute name="ncountry"><xsl:value-of select="."/></xsl:attribute>
        <xsl:attribute name="icountry"><xsl:value-of select="@country"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="institution[@content-type='normalized']">
        <xsl:attribute name="norgname"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="product" mode="product-in-article-meta">
        <xsl:element name="{name()}">
            <xsl:attribute name="prodtype"><xsl:value-of select="@product-type"/></xsl:attribute>
            <xsl:apply-templates select="*" mode="product-in-article-meta"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="product/*"  mode="product-in-article-meta">
        <xsl:apply-templates select="."/>
    </xsl:template>
    <xsl:template match="product/comment">
        <moreinfo><xsl:value-of select="."/></moreinfo>
    </xsl:template>
    <xsl:template match="product/year|product/month|product/day">
        <xsl:call-template name="dateiso">
            <xsl:with-param name="year"><xsl:value-of select="../year"/></xsl:with-param>
            <xsl:with-param name="month"><xsl:value-of select="../month"/></xsl:with-param>
            <xsl:with-param name="day"><xsl:value-of select="../day"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="size[@units='pages']">
        <extent><xsl:value-of select="."/></extent>
    </xsl:template>
    <xsl:template match="person-group">
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="@person-group-type='compiler'">org</xsl:when>
                <xsl:when test="@person-group-type='editor'">ed</xsl:when>
                <xsl:when test="@person-group-type='author'">nd</xsl:when>
                <xsl:when test="@person-group-type='translator'">tr</xsl:when>
                <xsl:otherwise>nd</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <authors role="{$type}">
            <xsl:apply-templates select="*"/>
        </authors>
    </xsl:template>
    <xsl:template match="person-group/name">
        <pauthor>
            <xsl:apply-templates select="*"/>
        </pauthor>
    </xsl:template>
    <xsl:template match="collab">
        <cauthor><xsl:apply-templates select="*|text()"/></cauthor>
    </xsl:template>
    <xsl:template match="contrib/collab">
        <corpauth><xsl:apply-templates select="*|text()"/></corpauth>
    </xsl:template>
    <xsl:template match="etal">
        <et-al>et-al</et-al>
    </xsl:template>
    <xsl:template match="chapter-title">
        <chptitle><xsl:apply-templates select="text()"/></chptitle>
    </xsl:template>
    <xsl:template match="publisher-loc">
        <publoc>
            <xsl:value-of select="normalize-space(.)"/>
        </publoc>
    </xsl:template>
    <xsl:template match="publisher-name">
        <pubname>
            <xsl:value-of select="normalize-space(.)"/>
        </pubname>
    </xsl:template>

    <xsl:template match="uri[@content-type='clinical-trial']">
        <cltrial>
            <xsl:apply-templates select="text()"/>
            <xsl:if test="@xlink:href != ''">
                <ctreg cturl="{@xlink:href}"></ctreg>
            </xsl:if>
        </cltrial>
    </xsl:template>

    <xsl:template match="history">
        <hist>
            <xsl:apply-templates select="date"/>
        </hist>
    </xsl:template>
    <xsl:template match="history/date">
        <xsl:variable name="dateiso">
            <xsl:value-of select="year"/><xsl:if test="not(year)">00</xsl:if>
            <xsl:value-of select="month"/><xsl:if test="not(month)">00</xsl:if>
            <xsl:value-of select="day"/><xsl:if test="not(day)">00</xsl:if>
        </xsl:variable>
        <xsl:variable name="dtype">
            <xsl:choose>
                <xsl:when test="@date-type='rev-recd'">revised</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@date-type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$dtype}">
            <xsl:attribute name="dateiso"><xsl:value-of select="$dateiso"/></xsl:attribute>
            <xsl:value-of select="$dateiso"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="related-article" mode="front-related">
        <xsl:variable name="reltp">
            <xsl:choose>
                <xsl:when test="@related-article-type='commentary'">press-release</xsl:when>
                <xsl:when test="@related-article-type='article-reference'">article</xsl:when>
                <xsl:otherwise><xsl:value-of select="@related-article-type"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <related reltp="{$reltp}">
            <xsl:attribute name="pid-doi">
                <xsl:choose>
                    <xsl:when test="string-length(@id)=23 and substring(@id,1)='S'"> <xsl:value-of select="@id"/></xsl:when>
                    <xsl:otherwise><xsl:value-of select="@xlink:href"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </related>
    </xsl:template>

    <xsl:template match="abstract|trans-abstract">
        <xsl:param name="language"/>
        <xmlabstr>
            <xsl:choose>
                <xsl:when test="@xml:lang"><xsl:attribute name="language"><xsl:value-of select="@xml:lang"/></xsl:attribute></xsl:when>
                <xsl:when test="$language!=''"><xsl:attribute name="language"><xsl:value-of select="$language"/></xsl:attribute></xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="count(p) &gt; 1 or sec or sectitle">
                    <xsl:apply-templates select="*|text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="p/*|p/text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xmlabstr>
    </xsl:template>

    <xsl:template match="kwd-group">
        <xsl:param name="language"/>
        <kwdgrp>
            <xsl:choose>
                <xsl:when test="@xml:lang"><xsl:attribute name="language"><xsl:value-of select="@xml:lang"/></xsl:attribute></xsl:when>
                <xsl:when test="$language!=''"><xsl:attribute name="language"><xsl:value-of select="$language"/></xsl:attribute></xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="title|kwd"/>
        </kwdgrp>
    </xsl:template>

    <xsl:template match="sec/title|kwd-group/title|ack/title|ref-list/title">
        <sectitle>
            <bold><xsl:apply-templates select="*|text()"/></bold>
        </sectitle>
    </xsl:template>

    <!-- xmlbody -->
    <xsl:template match="*" mode="body">
        <xmlbody>
            <xsl:apply-templates select="body"/>
        </xmlbody>
    </xsl:template>
    <xsl:template match="sec">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@sec-type | * | text()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="sec//sec">
        <subsec>
            <xsl:apply-templates select="@sec-type | * | text()"/>
        </subsec>
    </xsl:template>
    <xsl:template match="sup|sub|bold|italic">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | * | text()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="table-wrap"></xsl:template>
    <xsl:template match="p[disp-formula|fig|list|table-wrap|disp-quote|boxed-text|def-list]">
        <xsl:if test="normalize-space(text()) != ''">
            <p>
                <xsl:apply-templates select="text()|*[not(self::disp-formula|self::fig|self::list|self::table-wrap|self::disp-quote|self::boxed-text|self::def-list)]"/>
            </p>
        </xsl:if>
        <xsl:apply-templates select="disp-formula|fig|list|table-wrap|disp-quote|boxed-text|def-list"/>
    </xsl:template>
    <xsl:template match="disp-quote">
        <quote>
            <xsl:choose>
                <xsl:when test="count(*) &gt; 1"><xsl:apply-templates select="*|text()"/></xsl:when>
                <xsl:otherwise><xsl:apply-templates select="p/*|p/text()"/></xsl:otherwise>
            </xsl:choose>
        </quote>
    </xsl:template>
    <xsl:template match="def-list">
        <deflist>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="title|def-item|def-list"/>
        </deflist>
    </xsl:template>
    <xsl:template match="def-item">
        <defitem>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="term|def"/>
        </defitem>
    </xsl:template>
    <xsl:template match="def[p]">
        <def>
            <xsl:apply-templates select="*|text()"/>
        </def>
    </xsl:template>
    <xsl:template match="disp-formula|inline-formula">
        <equation>
            <xsl:apply-templates select="graphic|inline-graphic"/>
        </equation>
    </xsl:template>
    <xsl:template match="fig">
        <figgrp>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="graphic"/>
            <xsl:apply-templates select="label"/>
            <xsl:apply-templates select="caption"/>
        </figgrp>
    </xsl:template>
    <xsl:template match="caption/title">
        <caption>
            <xsl:value-of select="."/>
        </caption>
    </xsl:template>
    <xsl:template match="graphic|inline-graphic">
        <graphic>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="contains(@xlink:href, '.tif')"><xsl:value-of select="substring-before(@xlink:href, '.tif')"/>.jpg</xsl:when>
                    <xsl:when test="contains(@xlink:href, '.eps')"><xsl:value-of select="substring-before(@xlink:href, '.eps')"/>.jpg</xsl:when>
                    <xsl:otherwise><xsl:value-of select="@xlink:href"/></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <img>
                <xsl:attribute name="src">../src/<xsl:value-of select="@xlink:href"/></xsl:attribute>
            </img>
        </graphic>
    </xsl:template>
    
    <xsl:template match="table-wrap">
        <tabwrap>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="label"/>
            <xsl:apply-templates select="caption"/>
            <xsl:apply-templates select="graphic"/>
            <xsl:apply-templates select="table" mode="pmc-table"/>
        </tabwrap>
    </xsl:template>
    <xsl:template match="table" mode="pmc-table">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*|thead|tbody"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="th/@*">
        <xsl:attribute name="{name()}"><xsl:value-of select="normalize-space(.)"/></xsl:attribute>
    </xsl:template>
    <xsl:template match="thead | thead/tr | thead//th">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*|*|text()"></xsl:apply-templates>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ext-link[@ext-link-type='uri']">
        <uri>
            <xsl:apply-templates select="@xlink:href"></xsl:apply-templates>
            <xsl:value-of select="."/>
        </uri>
    </xsl:template>
    <xsl:template match="@xlink:href">
        <xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@* | *"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="list-item">
        <li>
            <xsl:apply-templates select="label"/>
            <xsl:choose>
                <xsl:when test="count(p) &gt; 1"><xsl:apply-templates select="@* | * | text()"/></xsl:when>
                <xsl:otherwise><xsl:apply-templates select="p/*|p/text()"/></xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    <xsl:template match="@list-type">
        <xsl:attribute name="listtype">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="list[not(@list-type) and count(list-item) = 1]">
        <quote>
            <xsl:choose>
                <xsl:when test="count(list-item/*) &gt; 1"><xsl:apply-templates select="list-item/*|list-item/text()"/></xsl:when>
                <xsl:otherwise><xsl:apply-templates select="list-item/p/*|list-item/p/text()"/></xsl:otherwise>
            </xsl:choose>
        </quote>
    </xsl:template>

    <xsl:template match="boxed-text">
        <boxedtxt>
            <xsl:apply-templates select="@id"/>
            <xsl:choose>
                <xsl:when test="sectitle">
                    <sec>
                        <xsl:apply-templates select="*|text()"/>
                    </sec>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*|text()"/>
                </xsl:otherwise>
            </xsl:choose>
        </boxedtxt>
    </xsl:template>

    <xsl:template match="inline-supplementary-material">
        <supplmat href="{@xlink:href}">
            <xsl:apply-templates select="*|text()"/>
        </supplmat>
    </xsl:template>
    <!-- back -->
    <xsl:template match="article" mode="back">
        <xsl:apply-templates select="back/ack"/>
        <xsl:apply-templates select="back/ref-list"/>
        <xsl:apply-templates select="front/article-meta/author-notes/fn|back/fn-group/fn"/>
    </xsl:template>
    
    <xsl:template match="back/ack">
        <xsl:element name="{name()}">
            <xsl:apply-templates select="*"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="back/ref-list">
        <refs>
            <xsl:apply-templates select="title"/>
            <xsl:apply-templates select="ref"/>
        </refs>
    </xsl:template>
    <xsl:template match="ref">
        <xsl:variable name="id"><xsl:choose>
            <xsl:when test="@id"><xsl:value-of select="string(number(substring(@id,2)))"/></xsl:when><xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
        </xsl:choose></xsl:variable>
        <xsl:element name="{name()}">
            <xsl:attribute name="id">r<xsl:value-of select="$id"/></xsl:attribute>
            <xsl:apply-templates select="element-citation/@publication-type"/>
            <xsl:apply-templates select="label"/>
            <xsl:apply-templates select="mixed-citation"/>
            <xsl:apply-templates select="element-citation"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@publication-type">
        <xsl:attribute name="reftype"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="mixed-citation">
        <text-ref>
            <xsl:value-of select="."/>
        </text-ref>
    </xsl:template>
    <xsl:template match="element-citation">
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="article-title">
        <arttitle><xsl:apply-templates select=".//text()"/></arttitle>
    </xsl:template>
    <xsl:template match="element-citation/pub-id[@pub-id-type='other']">
        <reportid><xsl:value-of select="normalize-space(.)"/></reportid>
    </xsl:template>
    <xsl:template match="patent">
        <patentno country="{@country}"><xsl:value-of select="normalize-space(.)"/></patentno>
    </xsl:template>
    <xsl:template match="element-citation/comment">
        <moreinfo><xsl:value-of select="normalize-space(.)"/></moreinfo>
    </xsl:template>
    <xsl:template match="element-citation/comment[content-type='award-id']">
        <contract><xsl:value-of select="normalize-space(.)"/></contract>
    </xsl:template>
    <xsl:template match="element-citation/year">
        <xsl:call-template name="dateiso">
            <xsl:with-param name="year"><xsl:value-of select="../year"/></xsl:with-param>
            <xsl:with-param name="month"><xsl:value-of select="../month"/></xsl:with-param>
            <xsl:with-param name="day"><xsl:value-of select="../day"/></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="element-citation/month|element-citation/day"/>
    <xsl:template match="element-citation/fpage">
        <pages>
            <xsl:value-of select="../fpage"/>
            <xsl:apply-templates select="../lpage"/>
            <xsl:if test="../lpage!=''">-<xsl:value-of select="../lpage"/></xsl:if>
        </pages>
    </xsl:template>
    <xsl:template match="element-citation/lpage"/>
    <xsl:template match="volume">
        <volid>
            <xsl:value-of select="normalize-space(.)"/>
        </volid>
    </xsl:template>
    <xsl:template match="issueno">
        <issueno>
            <xsl:value-of select="issue"/>
            <xsl:if test="issue-part"> <xsl:value-of select="issue-part"/></xsl:if>
        </issueno>
    </xsl:template>
    <xsl:template match="issue">
        <issueno>
            <xsl:value-of select="."/>
            <xsl:if test="..//issue-part"> <xsl:value-of select="..//issue-part"/></xsl:if>
        </issueno>
    </xsl:template>
    <xsl:template match="element-citation//ext-link[@ext-link-type='uri']">
        <url>
            <xsl:value-of select="@xlink:href"/>
        </url>
    </xsl:template>
    <xsl:template match="element-citation/pub-id">
        <pubid>
            <xsl:attribute name="idtype"><xsl:value-of select="@pub-id-type"/></xsl:attribute>
            <xsl:value-of select="."/>
        </pubid>
    </xsl:template>
    <xsl:template match="element-citation/date-in-citation[@content-type='access-date']">
        <cited>
            <xsl:attribute name="dateiso"><xsl:value-of select="translate(@iso-8601-date, '-', '')"/></xsl:attribute>
            <xsl:value-of select="."/>
        </cited>
    </xsl:template>
    <xsl:template match="element-citation/conference">
        <!-- TODO -->
        <xsl:apply-templates select="text()"/>
    </xsl:template>
    <xsl:template match="fn/@fn-type">
        <xsl:attribute name="fntype">
            <xsl:choose>
                <xsl:when test=".='other'">author</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="fn/label">
        <xsl:attribute name="{name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="author-notes/fn|fn-group/fn">
        <fngrp>
            <xsl:apply-templates select="@*"/>
            <xsl:if test="not(@fn-type)">
                <xsl:attribute name="fntype">other</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="label"/>
            <xsl:apply-templates select="p/*|p/text()"/>
        </fngrp>
    </xsl:template>
</xsl:stylesheet>
