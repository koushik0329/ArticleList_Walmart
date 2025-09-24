//
//  EmpViewModel.swift
//  ArticleList_Walmart
//
//  Created by Koushik Reddy Kambham on 9/21/25.
//

class EmpViewModel {
    
    var empList : [Emp] = [Emp(name: "Koushik", id: 30), Emp(name: "Sai", id: 25), Emp(name: "Ravi", id: 28)]
    
    func getEmpList(at index: Int) -> Emp {
        return empList[index]
    }
    
    func getEmpCount() -> Int {
        return empList.count
    }
}
