#include <iostream>
#include <optional>
#include <array>
#include <string>
#include <conio.h>
#include "tinyexpr.h"

int index = 0;
int index2 = 0;

std::optional<std::array<int, 4>> swapper(std::array<int, 4> nums) {
	auto arr = nums;
	if (index2 > 3)
		return std::nullopt;
	if (index <= 3)
		std::swap(arr[index2], arr[index]);
	else {
		index = 0;
		index2++;
	}
	index++;
	return arr;
}
int main() {
	auto decide = [](float index) {
		if (index == 0) return "+";
		if (index == 1) return "-";
		if (index == 2) return "*";
		if (index == 3) return "/";
	};
	auto mainproc = [&]() {
		std::array<int, 4> origNums = { 0, 0, 0, 0 };
		std::cout << "Input the 4 digits:\n";
		std::string input;
		std::cin >> input;
		for (int i = 0; i < 4; ++i) {
			origNums[i] = std::stoi(std::string() + input[i]);
		}
		for (;;) {
			std::array<int, 4> nums{};
			auto opnums = swapper(origNums);
			if (opnums.has_value())
				nums = opnums.value();
			else {
				std::cout << "Result: No solution found!\nPress any key...";
				(void)_getch();
				return;
			}
			for (float ac = 0; ac < 4; ++ac) {
				for (float bc = 0; bc < 4; ++bc) {
					for (float cc = 0; cc < 4; ++cc) {
						std::string expr = std::to_string(nums[0]) + decide(ac) + std::to_string(nums[1]) + decide(bc)
							+ std::to_string(nums[2]) + decide(cc) + std::to_string(nums[3]);
						float result = (float)te_interp(expr.c_str(), 0);
						if (result == 10.f) {
							std::cout << "Result: " << expr << "\nPress any key...";
							(void)_getch();
							return;
						}
					}
				}
			}
		};
	};
	for (;;) {
		index = 0;
		index2 = 0;
		mainproc();
		system("CLS");
	}
}
