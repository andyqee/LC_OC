
func find2(_ nus : [Int]) -> Int {

	var map = [Int : Int]()
	for i 0..< num.length - 1 {
		map[i] = map.contains(num[i]) ? map[i] + 1 : 1
 	}
 	NSArray *nums = map.allValues.sort() //返乡排序
 	return nums[1] // 返回第二个
}


func find2(_ nus : [Int]) -> Int {

	var map = [Int : Int]()
	for i 0..< num.length - 1 {
		map[i] = map.contains(num[i]) ? map[i] + 1 : 1
 	}
 	NSArray *nums = map.allValues.sort() //返乡排序
 	return nums[1] // 返回第二个
}

a
b
c
d


if ( ((a.x + b.x) / 2  - c.x ) * ((a.x + b.x) / 2  - d.x ) > 0 &&  ((a.y + b.y) / 2  - c.xy ) * ((a.y + b.y) / 2  - d.y ) > 0  ) {
	return false // 没有正确路径
}

func func6(_ nums : [Int]) -> Int {
	let lenght = nums.count
	var map = [Int](repeating: 0, count: length + 1) //

	map[2] = (nums[1] > nums[0]) ? nums[1] * nums[0] : 0

 	let largest = max(nums[1], nums[0])

	for i [3, length] {
			if nums[i-1] > largest {
				map[i] = map[i-1] * mum[i-1] / largest
				largest = nums[i-1]
			} else {

				map[i] = map[i-1]
			}
		} 

	}

	return map [length]
}