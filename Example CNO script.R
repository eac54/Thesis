library(CellNOptR)
dir.create("CNOR_analysis_cell_line_1")

#Load in MIDAS data and prior knowledge network
cnolist1=CNOlist("MD_example_1.csv")
pknmodel<-readSIF("PKN.sif")
data(cnolist1, package="CellNOptR")
data(pknmodel, package="CellNOptR")

#Plot data from "MD_example_1.csv" and save as a pdf
plotCNOlist(cnolist1)
plotCNOlistPDF(CNOlist=cnolist1, filename="ModelGraphCellLine1.pdf")

#Preprocessing of the data - CNOR removes non observable and non controllable species, compresses the model and expands logic gates
NCNOcutCompExp2 = preprocessing(cnolist1, pknmodel, verbose=FALSE)
#create an initial bit string for the optimisation, which in this case is just a string of 1s as we have no prior expectation about the model topology
initBstring2<-rep(1,length(NCNOcutCompExp2$reacID))
#Run the genetic algorithm for model optimisation for time point 1
T1opt2<-gaBinaryT1(CNOlist=cnolist1, model=NCNOcutCompExp2, initBstring=initBstring2, stallGenMax=10, maxTime=60, verbose=FALSE)

cutAndPlot( model=NCNOcutCompExp2, bStrings=list(T1opt2$bString), CNOlist=cnolist1, plotPDF=TRUE)

pdf("CellLine1T1.pdf")
plotFit(optRes=T1opt2)
dev.off()
pdf 2 
plotFit(optRes=T1opt2)

cutAndPlot(model=NCNOcutCompExp2, bStrings=list(T1opt2$bString, T1opt2T2$bString), CNOlist=cnolist1, plotPDF=TRUE, plotParams=list(cex=0.8, cmap_scale=0.5, margin=0.2))

pdf("CellLine1Graph2.pdf")
plotFit(optRes=T1opt2T2)
dev.off()
writeScaffold(modelComprExpanded=NCNOcutCompExp2, optimResT1=ToyT1opt2, modelOriginal=ToyModel2, CNOlist=CNOlistToy2)
writeNetwork( modelOriginal=ToyModel2,modelComprExpanded=ToyNCNOcutCompExp2,optimResT1=ToyT1opt2, optimResT2=ToyT1opt2T2,CNOlist=CNOlistToy2)

namesFilesToy<-list(dataPlot="ToyModelGraphT2.pdf",evolFitT1="evolFitToy2T1.pdf", evolFitT2="evolFitToy2T2.pdf", simResultsT2="SimResultsTN.pdf", simResultsT1="SimResultsT1_1.pdf",scaffold="Scaffold.sif", scaffoldDot="Scaffold.dot", tscaffold="TimesScaffold.EA",  wscaffold="weightsScaffold.EA", PKN="PKN.sif", PKNdot="PKN.dot", wPKN="TimesPKN.EA", nPKN="nodesPKN.NA")

writeReport(modelOriginal=ToyModel2, modelOpt=ToyNCNOcutCompExp2,  optimResT1=ToyT1opt2, optimResT2=ToyT1opt2T2, CNOlist=CNOlistToy2, directory="testToy2", namesFiles=namesFilesToy, namesData=list(CNOlist="ToyModified4T2",model="ToyModified4T2"))

