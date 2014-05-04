Working with GView Server
=========================

Introduction
------------

[GView Server][gview-server] is a web-based application for performing comparative genomics analysis.  Genomes can be uploaded and multiple categories of analysis types can be performed on these genomes.  The types of analysis include:

* BLAST Atlas
* Pangenome BLAST Atlas
* Core genome
* Unique genes
* Signature genes
* Reciprocal BLAST

Each of these analysis types use BLAST to perform comparisons among a set of genomes.  Results for each analysis type are displayed using [GView][gview], a circular and linear genome viewer.  GView can be used to make modifications to the appearance of the results and export the genome map to an image file.

In this lab, we will go through a number of different analysis types using GView Server and how to modify the results in GView.

Lab 1: Viewing Genomes
----------------------

This exercise will provide an introduction to loading a single GenBank file into GView through GView Server.  This can be used to quickly load up and customize the appearance of a genome file.

1. **Go to GView Server**
    1. Go to <http://server.gview.ca>.  You should see a page similar to the following.

        ![main gview server][main-1.jpg]

2. **Select Analysis Type**
    1. Set Analysis Type to Display genome features
3. **Upload Genome**
    1. **Click on Browse ...**
    2. Find */Course/MI_workshop_2014/day6/gview-server-annotations/reference/2010EL-1786-c1.gbk*
    3. Click **Continue**.  You should be brought to a screen that looks like the following.

        ![gview customize][lab1-1.jpg]

4. **Set Title**
    1. Enter *2010EL-1786 Chromosome I* for the **Map title**.
5. **Set Features to Display**
    1. Find the **Display reference features** box and click on the **Edit Features** ![edit features][edit.png] icon.
    2. Make sure *rRNA*, *CDS*, and *tRNA* are selected.  Click on the **Close** ![close][close.png] icon.
6. **Add Additional Data**
    1. Click on the **Show GC Content** and **Show GC Skew** boxes to make sure these are included in the results.  *Note: The COG category analysis takes a little while to process so we will skip out of performing this analysis in the labs.*
7. **Adjust Appearance**
    1. In the section titled **Additional Customizations** find the row marked as *2010EL-1786-c1.gbk*.
    2. Click on the **Edit track styles** ![edit style][edit.png] icon.  Your screen should appear like the following.

        ![edit appearance][lab1-2.jpg]

    3. Find the **Feature colour** row and click on the coloured box.  From here, adjust the colour of the features to display.
    4. Click on the ![check][check.png] icon to close.  Click on the **ok** button to go back to the customize screen.
8. **Submit Data**
    1. Click on **Complete** once all appearance customizations are finished.  You should see a screen similar to below.

        ![complete][lab1-3.jpg]

9. **Wait for Results**
    1. Click on the *Job ID* number to view the status and wait for the results.  Once complete you should be brought to a page that looks like the following.

        ![gview results][lab1-4.jpg]

10. **View Results**
    1. You can click on the **Launch GView Webstart Circular** or **Launch GView Webstart Linear** links to view the results in GView.
    2. You can click on the *gview-all* links in the **Download** section to download the resulting data and the GView viewer.

An example of these results can be found at <http://server.gview.ca/w/2014/L1>.

*Note:    All sequence files (such as GenBank) must include sequence data in order to work with GView Server.  That is, if you opened up the file within a text editor you should see some text that looks like:*

```
ORIGIN
          1 tttcatcagg tcgtttatgg taattttttt catgtttagt ccttactcga cgttggcgag
         61 tgccaaatgc tgagcccatt gagcggtact tgttgcaata acgcttggat ttcagtcccg
```

*If, instead, you see the following within the text file then you'll have to obtain the version of the file with the sequence data included (NCBI by default does not include sequence data when downloading a GenBank file).*

```
ORIGIN        
//
```


Lab 2: BLAST Atlas
------------------

A BLAST Atlas is used to depict the presence and absence of particular regions within a set of genomes.  The presence or absence of a region is determined by running [BLAST][blast] between these regions.  The BLAST results are compiled into a table and are used to generate an image using GView.  In order to construct a BLAST Atlas using the cholera data please proceed through the following steps.

1. **Go to GView Server**
    1. Go to <http://server.gview.ca>.
2. **Select Analysis Type**
    1. Set the **Analysis Type** to *BLAST Atlas*.
3. **Upload Reference Genome**
    1. Click on **Browse** and find */Course/MI_workshop_2014/day6/gview-server-annotations/2010EL-1786-c1.gbk*.  This will be the reference genome used to run BLAST.
    2. Click **Continue**.  This will now upload the reference genome to GView Server.
4. **Upload Query Genomes**
    1. Click on **Browse** next to **Select a sequence file**.
    2. Select */Course/MI_workshop_2014/day6/gview-server-annotations/other-genomes/2010EL-1749.gbk*.
    3. Click on the **Plus** icon ![plus][plus-button.png] to add a new file to upload.
    4. Click on **Browse** and select the file *VC-1.gbk*.
    5. Click on **Continue** when finished.  This should now upload all the selected genomes to GView Server.
5. **Adjust BLAST Parameters**
    1. In this screen it's possible to adjust some of the settings for BLAST.  For this example we will keep the default settings.  Click on **Continue** to proceed.
6. **Customize Appearance**
    1. In this screen it's possible to adjust the appearance settings of the BLAST Atlas.  Within the **Map title** text field please enter *2010EL-1786 Chromosome I*.
    2. Feel free to adjust any other settings and click on **Complete** to start the analysis.
7. **Wait for Analysis Results**
    1. The next screen will give you a job ID where your results can be found.  Click on the link and wait for your analysis results to appear.
    2. On completion the results should look similar to below.  An example of the results can also be found at <http://server.gview.ca/w/2014/L2>.

        ![lab2-atlas][lab2-1.jpg]

### Questions

1. *V. Cholerae* contains two circular chromosomes but this lab only used Chromosome I (2010EL-1786-c1.gbk) for a BLAST Atlas.  Please construct a BLAST atlas for Chromosome II (2010EL-1786-c2.gbk) by following a similar procedure as above.  What differences do you notice between the chromosomes?

[Answers](Answers.md)

Lab 3: Pan-genome BLAST Atlas
-----------------------------

In the previous lab, we constructed separate BLAST Atlases for the two chromosomes of *V. Cholerae*.  This was necessary because we are using BLAST to compare all query genomes to some pre-defined reference genome.  If this reference genome is missing any data that is contained in the query genomes (like a separate chromosome, or plasmids) these would not show up within the BLAST Atlas.  It would be nice if we were able to combine all these separate genomic elements (chromosomes, plasmids, etc) into a single reference file so we can quickly get a picture of all the differences among the genomes.  This can be accomplished using the **Pan-genome BLAST atlas** analysis type which first constructs a pan-genome from all the uploaded genomes and then uses this pan-genome as the reference to run BLAST queries against.

In order to construct a pan-genome BLAST atlas please proceed through the following steps.

1. **Go to GView Server**
2. **Select Analysis Type**
    1. Set the **Analysis Type** to *Pangenome Analysis*.
    2. There is no reference genome to upload for this analysis since it will be constructed for you.  Click **Continue** to proceed.
3. **Upload Genomes**
    1. Click on **Browse** next to **Select a sequence file**.
    2. Select */Course/MI_workshop_2014/day6/gview-server-annotations/reference/2010EL-1786-c1.gbk* (Chromosome I).
    3. Click on the **Plus** icon ![plus][plus-button.png] to add a new file to upload.
    4. Select *2010EL-1786-c2.gbk* (Chromosome II).
    5. Add the files *2010EL-1749.gbk* and *VC-1.gbk* using the same method.
    6. Click on **Continue** when finished.  This should now upload all the selected genomes to GView Server.
4. **Adjust BLAST Parameters and Seed Genome**
    1. In this screen it's possible to adjust some of the settings for BLAST as well as to select the seed genome.  The seed genome is the genome used as a starting point for constructing the pan-genome.  Please make sure that *2010EL-1786-c1* is selected as the seed genome.
    2. Click on **Continue** to proceed.
5. **Customize Appearance**
    1. In this screen it's possible to adjust the appearance settings of the BLAST Atlas.  Within the **Map title** text field please enter *Seed Chromosome I*.
    2. Feel free to adjust any other settings and click on **Complete** to start the analysis.
6. **Wait for Analysis Results**
    1. The next screen will give you a job ID where your results can be found.  Click on the link and wait for your analysis results to appear.
    2. On completion, your results should look similar to below.  An example of the results can be found at <http://server.gview.ca/w/2014/L3>.

    ![pangenome atlas][lab3-1.jpg]

*Note: When constructing a pan-genome BLAST Atlas, the files should be divided such that one file corresponds to one genome, and each file contains genes (not contigs).  This is so we can find unique genes to construct the pan-genome.  These files can either be in __gbk__ or __fasta__ format.  For example:*

*gbk*

```
    FEATURES             Location/Qualifiers
       source          1..15175
                       /organism="Genus species"
                       /mol_type="genomic DNA"
                       /strain="strain"
       CDS             312..1373
                       /gene="pleD_1"
                       /locus_tag="2010EL-1749_00001"
                       /inference="ab initio prediction:Prodigal:2.60"
```

*fasta*

```
    >2010EL-1749_00001 Stalked cell differentiation-controlling protein
    ATGGATGCTAGGTTATTTGACAATACACAAACGCTTCGAGCTTCAGTGCTATGCGGCCTA
    AGTTTCTTTTGGGCTTTGATCGCTTTCTTGATGGCGCTGATCAATTTCTGGTCAACACGG
    TTAGTCGAACTCGCGTCACTTGAGCTCGTTTGCGCTTTCTACTCCCTGTATATTTATTCT
    CTGGCTAAGCGTCGTATTCATACCAAACAACAAGTTTATCTTTATTTGTTTATATTAACT
```

### Questions

1. In **Lab 2** we constructed a BLAST Atlas using *Chromosome I* as a reference.  Compare the BLAST Atlas using *Chromosome I* to the pan-genome BLAST Atlas constructed in **Lab 2**.  What extra information do you see in the pan-genome BLAST Atlas?

2. In this lab we constructed a pan-genome BLAST Atlas using *Chromosome I* as the seed genome.  Please follow through the same procedure, but this time use *Chromosome II* as the seed genome.  What differences do you notice?

[Answers](Answers.md)

Lab 4: Working with GView
-------------------------

In this lab we will look at exploring the results of GView Server within [GView][gview].    GView is a circular and linear genome viewer which provides the ability to customize the appearance of the genome map, add new data to display, and export the results.  In order to start working with GView please follow the steps below.

1. **Launch GView**
    1. Go to the results page for **Lab 3** or <http://server.gview.ca/w/2014/L3>.
    2. Find the **Launch GView Webstart Circular** link and click on it.  This should bring up a window asking you to open up the file **gview-circular.jnlp**.  Click **Ok** and wait for GView to finish loading.  When finished loading, you should get a window that looks like the following.

        ![gview 1][lab4-1.jpg]

2. **Exploring the Genome**
    1. Panning can be accomplished by clicking on and moving the screen.
    2. Zooming can be accomplished by using the **mouse wheel**, going to **View > Zoom**, or using the ![zoom in][zoom-in.png] ![zoom out][zoom-out.png] ![scale in][scale-in.png] ![scale out][scale-out.png] icons.
    3. Elements (such as the Legend, Ruler, Labels) can be turned on/off by going to View and turning on/off the element to view.
    4. Once you are comfortable navigating in the genome viewer, you can proceed to the next step.
3. **Changing the Appearance**
    1. Select **Style > Style Editor**.  In the Style Editor window the different style elements that can be changed are on the left.  You should see a screen that looks like the following.

        ![gview 2][lab4-2.jpg]

    2. Find **Slots > Slot -1 > ((Type: "CDS" ...)** and click on it to expand the entry.  This contains settings for defining the style of slot -1 (the innermost slot).  To the right you should see the different parts of this set of features that can be changed.  This should look like the following.

         ![gview slot -1][lab4-3.jpg]

    3. Find the box marked **Color** and click on it.  Adjust the color to whatever you see fit.
    4. When finished, click **Ok** on the color window, and then **Apply** in the style editor window.  You should see the color of the displayed features change.  Feel free to modify any other appearance settings at this point.
    5. When finished, click **Ok** to exit out of the Style Editor and go back to the main GView window.
4. **_Exporting an Image_**
    1. In the main GView window, select **File > Export View As ...** and save to lab4.png.  You should now see this image in your home directory.
5. **Exit GView**
    1. To quite GView, go to **File > Exit**.

### Questions

1. The pan-genome BLAST Atlas in **Lab 3** was constructed using only three separate genomes.  It's possible to add as many genomes as you want by simply adding more files in the **Upload Genomes** screen.  A quick method to add a large number of files is to compress all the files first within a **zip** or **tar** archive.  An example of such a set of files is at */Course/MI_workshop_2014/day6/gview-server-annotations/other-genomes-ffn.tar.gz* (compressed file containing annotations for all genomes in ffn format).

One downside to large datasets is the longer time it takes to perform the analysis.  A pre-computed pan-genome analysis with the above set of files is displayed below and can be found at <http://server.gview.ca/w/2014/L4Q1>.

    ![pangenome all][lab4-4.jpg]

Please load up this BLAST Atlas in GView and take some time to look at the data.  In order to make it easier to navigate, you may want to turn on lower quality rendering by selecting **View > Quality > Low**.

2. The exact same dataset from the previous question was used in **Question 2** from the [OrthoMCL](../orthomcl/README.md) lab.    In reference to the resulting [Venn Diagram](../orthomcl/Answers.md) from this lab, please answer the following.

    1. The venn diagram shows that 3269 genes are part of the core genome set.  How do the 3269 core genes correspond to what is displayed in the BLAST Atlas?
    2. The venn diagram shows that there are 74 genes that are unique to only the haiti and nepal group.  That is, there are 74 genes that are found in every genome except C6706.  Can you find some of these region(s) on the pan-genome BLAST Atlas?

[Answers](Answers.md)

[gview-server]: http://server.gview.ca
[gview]: http://www.gview.ca
[blast]: http://en.wikipedia.org/wiki/BLAST

[main-1.jpg]: images/gview-server-main.jpg
[lab1-1.jpg]: images/gview-server-customize.jpg
[lab1-2.jpg]: images/lab1-appearance.jpg
[lab1-3.jpg]: images/gview-complete.jpg
[lab1-4.jpg]: images/gview-results-1.jpg
[lab2-1.jpg]: images/lab2-atlas-1.jpg
[lab3-1.jpg]: images/lab3-atlas-c1.jpg
[lab4-1.jpg]: images/lab4-gview-1.jpg
[lab4-2.jpg]: images/lab4-style-editor-2.jpg
[lab4-3.jpg]: images/lab4-slot_-1_3.jpg
[lab4-4.jpg]: images/lab4-pangenome-all.jpg
[plus-button.png]: images/plus-button.png
[zoom-in.png]: images/magnifier-zoom-in.png
[zoom-out.png]: images/magnifier-zoom-out.png
[scale-in.png]: images/magnifier-plus.png
[scale-out.png]: images/magnifier-minus.png
[edit.png]: images/application-pencil.png
[close.png]: images/cross-button.png
[check.png]: images/tick-button.png
