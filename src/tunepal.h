#ifndef TUNEPAL_H
#define TUNEPAL_H

#include <godot_cpp/classes/node2d.hpp>

namespace godot {

class Tunepal : public Node2D {
	GDCLASS(Tunepal, Node2D)

private:
	

protected:
	static void _bind_methods();

public:
	Tunepal();
	~Tunepal();

	void _process(double delta) override;

	void say_hello();

	int edSubstring(const godot::String needle, const godot::String haystack, const int thread_id);

    // int edSubstring(string
};

}

#endif