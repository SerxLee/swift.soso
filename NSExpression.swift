//
//  MyPlayground.swift
//  
//
//  Created by Serx on 16/01/09.
//
// 

//the method of the NSExpression ,such as count, min, max, 
//average, median, mode, absolute value and many more. 
//There i use the sum method to make a demo

class Expression{

	func sumThe(){

		let fetchRequest = NSFetchRequest(entityName: "Venue")
        fetchRequest.resultType = .DictionaryResultType //the result with the type of Dictonary
        

        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sumDeals" //name is the Key of dictionary

        
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "specialCount")])
        sumExpressionDesc.expressionResultType = .Integer32AttributeType


        //tell the original fetch request that i want to fetch the sum 
        //by setting its propertiesToFetch property tp the expression description

        //you can add more expression description
        fetchRequest.propertiesToFetch = [sumExpressionDesc]



        do{
            let result = try coreDataStack.context.executeFetchRequest(fetchRequest) as! [NSDictionary]
            
            let resultDict = result.first!
            let number = resultDict["sumDeals"]
            numDealsLabel.text = "\(number) total deals"
            
            
        }catch let error as NSError{
            print("Could not fetch:\(error), \(error.userInfo)")
        }


	}

}