Working with GView Server
=========================

Introduction
============

![gview-server-main][main-1]

[GView Server][gview-server] is a web-based application for performing comparative genomics analysis.  Genomes can be uploaded and multiple categories of analysis types can be performed on these files.  The types of analysis include:

* BLAST Atlas
* Pangenome BLAST Atlas
* Core genome
* Unique genes
* Signature genes
* Reciprocal BLAST

Results for each analysis type are displayed using [GView][gview] a circular and linear genome viewer.  GView can be used to make modifications to the appearance of the results and export the genome map to an image file.

In this lab, we will go through a number of different analysis types using GView Server, and how to modify the results in GView.

Lab 1: BLAST Atlas
------------------

A BLAST ATlas is used to depict the prescence and abscence of particular regions within a set of genomes.  The precscence or abscence of a region is determined by running [BLAST][blast] between these regions.  The BLAST results are compiled into a table and are used to generate an image using GView.  In order to construct a BLAST Atlas using the cholera data please proceed through the following steps.

1. **_Go to GView Server_**
  1. Go to http://server.gview.ca.
2. **_Select Analysis Type_**
  1. Set the **Analysis Type** to *BLAST Atlas*.
3. **_Upload Reference Genome_**
  1. Click on **Browse** and find */Course/MI_workshop_2014/day6/gview-server-annotations/2010EL-1786-c1.gbk*.  This will be the reference for used to run BLAST against.
  2. Click **Continue** (you can optionally enter your email address if you want the results emailed to you).  This will now upload the reference genome to GView Server.
4. **_Upload Query Genomes_**
  1. Click on **Browse** next to **Select a sequence file**.
  2. Select */Course/MI_workshop_2014/day6/gview-server-annotations/other-genomes/2010EL-1749.gbk*.
  3. Click on the **Plus** icon ![plus][plus-button] to add a new file to upload.
  4. Click on **Browse** and select the file *VC-1.gbk*.
  5. Click on **Continue** when finished.  This should now upload all the selected genomes to GView Server.
5. **_Adjust BLAST Parameters_**
  1. In this screen it's possible to adjust some of the settings for BLAST.  For this example we will keep the default settings.  Click on **Continue** to proceed.
6. **_Customize Appearance_**
  1. In this screen it's possible to adjust the appearance settings of the BLAST Atlas.  Within the **Map title** text field please enter *Lab 1: 2010EL-1786 Chromosome I*.
  2. No other settings need to be adjusted so click on **Complete** to start the analysis.
7. **_Wait for Analysis Results_**
  1. The next screen will give you a job id where your results can be found on completion.  Click on the link and wait for your analysis results to finish.
  2. On completion, you should see a screen similar to below.  An example of the results can also be found at http://server.gview.ca/w/2014/1.

     ![lab1a-results](images/lab1a-results.jpg)

     The BLAST Atlas generated will look similar to below.

     ![lab1a-atlas](images/lab1a-atlas.jpg)

### Questions

1. *V. Cholerae* contains two circular chromosomes but this lab only used Chromosome I (2010EL-1786-c1.gbk) for a BLAST Atlas.  Please construct a BLAST atlas for Chromosome II (2010EL-1786-c2.gbk) by following a similar procedure as above.  What differences do you notice between the chromosomes?

[Answers](Answers.md)

Lab 2: Pan-genome BLAST Atlas
-----------------------------

In the previous lab, we constructed separate BLAST Atlases for the two chromosomes of *V. Cholerae*.  This was necessary because we are using BLAST to compare all query genomes to some pre-defined reference genome.  If this reference genome is missing any data that is contained in the query genomes (like a separate chromosome, or plasmids, or other genomic elements) these would not show up within the BLAST Atlas.  It would be nice if we were able to combine all these separate genomic elements (chromosomes, plasmids, etc) into a single reference file so we can quickly get a picture of all the differences among the genomes.  This can be accomplished using the **Pan-genome BLAST atlas** analysis type which first constructs a pan-genome from all the uploaded genomes and then uses this pan-genome as the reference to run BLAST queries against.

In order to construct a pan-genome BLAST atlas please proceed through the following steps.

1. **_Go to GView Server_**
2. **_Select Analysis Type_**
  1. Set the **Analysis Type** to *Pangenome Analysis*.
  2. There is no reference genome to upload for this analysis, so click *Continue* to proceed.
4. **_Upload Genomes_**
  1. Click on **Browse** next to **Select a sequence file**.
  2. Select */Course/MI_workshop_2014/day6/gview-server-annotations/reference/2010EL-1786-c1.gbk* (Chromosome I).
  3. Click on the **Plus** icon ![plus][plus-button] to add a new file to upload.
  4. Select *2010EL-1786-c2.gbk* (Chromosome II).
  5. Add the files *2010EL-1749.gbk* and *VC-1.gbk* using the same method.
  6. Click on **Continue** when finished.  This should now upload all the selected genomes to GView Server.
5. **_Adjust BLAST Parameters and Seed Genome_**
  1. In this screen it's possible to adjust some of the settings for BLAST as well as to select the seed genome.  The seed genome is the genome used as a starting point for constructing the pan-genome.  Please make sure that *2010EL-1786-c1* is selected as the seed genome.
  2. Click on **Continue** to proceed.
6. **_Customize Appearance_**
  1. In this screen it's possible to adjust the appearance settings of the BLAST Atlas.  Within the **Map title** text field please enter *Lab 2: Seed Chromosome I*.
  2. No other settings need to be adjusted so click on **Complete** to start the analysis.
7. **_Wait for Analysis Results_**
  1. The next screen will give you a job id where your results can be found on completion.  Click on the link and wait for your analysis results to finish.
  2. On completion, your results should look similar to below.  An example of the results can be found at http://server.gview.ca/w/2014/2.

  ![lab2-atlas][lab2-1]

### Questions

1. The previous walkthrough had you construct a pan-genome BLAST Atlas using Chromosome I as the seed genome.  Please follow through the same procedure, but this time use Chromosome II as the seed genome.  What differences do you notice?

[Answers](Answers.md)

Lab 3: Working with GView
-------------------------

In this lab we will look at exploring the results of GView Server within [GView][gview].  GView is a ciruclar and linear genome viewer which provides the ability to customize the appearance of the genome map, add new data to display, and export the results.  In order to start working with GView please follow the steps below.

1. **_Launch GView_**
  1. Go to the results page for **Lab 2** or http://server.gview.ca/w/2014/2.
  2. Find the Launch GView Webstart Circular link and click on it.  This should bring up a window asking you to open up the file gview-circular.jnlp.  Click Ok and wait for GView to finish loading.  When finished loading, you should get a window that looks like the following.

    ![lab3-gview-1][lab3-1]

2. **_Exploring the Genome_**
  1. Panning can be accomplished by clicking on and moving the screen.
  2. Zooming can be accomplished by using the **mouse wheel**, going to **View > Zoom**, or using the ![zoom in][zoom-in] ![zoom out][zoom-out] ![scale in][scale-in] ![scale out][scale-out] icons.
  3. Elements (such as the Legend, Ruler, Labels) can be turned on/off by going to View and turning on/off what to view.
  4. Once you are satisfied with navigating in the genome viewer, you can proceed to the next step.
3. **_Changing the Appearance_**
  1. Select **Style > Style Editor**.  In the Style Editor window the different style elements that can be changed are on the left.  You should see a screen that looks like the following.

    ![lab3-gview-2][lab3-2]

  2. Find **Slots > Slot -1 > ((Type: "CDS" ...)** and click on it to expand the entry.  This contains settings for defining the style of slot -1 (the innermost slot).  To the right you should see the different parts of this set of features that can be changed.  This should look like the following.

     ![lab3 slot -1][lab3-3]

  3. Find the box marked **Color** and click on it.  Adjust the color to whatever you see fit.
  4. When finished, click **Ok** on the color window, and then **Apply** in the style editor window.  You should see the color of the features displayed change.  Feel free to modify any other appearance settings at this point.
  5. When finished, click **Ok** to exit out of the Style Editor and go back to the main GView window.
4. **_Exporting an Image_**
  1. In the main GView window, select **File > Export View As ...** and save to lab3.png.  You should now see this image in your home directory.
5. **_Exit GView_**
  1. To quite GView, go to **File > Exit**.


[gview-server]: http://server.gview.ca
[gview]: http://www.gview.ca
[blast]: http://en.wikipedia.org/wiki/BLAST

[main-1]: images/gview-server-main.jpg
[lab2-1]: images/lab2-atlas.jpg
[lab3-1]: images/lab3-gview-1.jpg
[lab3-2]: images/lab3-style-editor-2.jpg
[lab3-3]: images/lab3-slot_-1_3.jpg
[plus-button]: images/plus-button.png
[zoom-in]: images/magnifier-zoom-in.png
[zoom-out]: images/magnifier-zoom-out.png
[scale-in]: images/magnifier--plus.png
[scale-out]: images/magnifier--minus.png
